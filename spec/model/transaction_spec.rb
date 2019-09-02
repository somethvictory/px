require 'rails_helper'

RSpec.describe Transaction, 'Validations', type: :model do
  it { is_expected.to validate_presence_of(:amount_spent) }
end

RSpec.describe Transaction, 'Associations', type: :model do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:country) }
end

RSpec.describe Transaction, 'Static Scope', type: :model do
  let(:user) { create(:user) }
  let(:au)   { create(:country, code: 'au', name: 'Australia') }
  let!(:transaction1) { create(:transaction, user: user, amount_spent: 50, created_at: '2019-01-01')  }
  let!(:transaction2) { create(:transaction, user: user, country: au, amount_spent: 90, created_at: '2019-01-02')  }
  let!(:transaction3) { create(:transaction, user: user, amount_spent: 120, created_at: '2019-02-03') }
  let!(:transaction4) { create(:transaction, user: user, amount_spent: 120, created_at: '2019-03-01') }
  let!(:transaction5) { create(:transaction, user: user, country: au, amount_spent: 80, created_at: '2019-04-01')  }
  let!(:transaction6) { create(:transaction, user: user, amount_spent: 20, created_at: '2019-04-02')  }
  let!(:transaction7) { create(:transaction, user: user, amount_spent: 500, created_at: '2019-06-01') }

  context 'with .total_spend' do
    it 'returns the total amount spent' do
      expect(described_class.total_spend).to eq Transaction.sum(:amount_spent)
    end
  end

  context 'with .monthly_spend' do
    it 'returns total spend grouped by month' do
      records = described_class.monthly_spend
      expect(records[0].monthly_spend).to eq 140
      expect(records[0].month).to eq '01'
      expect(records[1].monthly_spend).to eq 120
      expect(records[1].month).to eq '02'
      expect(records[2].monthly_spend).to eq 120
      expect(records[2].month).to eq '03'
      expect(records[3].monthly_spend).to eq 100
      expect(records[3].month).to eq '04'
      expect(records[4].monthly_spend).to eq 500
      expect(records[4].month).to eq '06'
    end
  end

  context 'with .eligible_for_free_coffee?' do
    it 'returns true when any monthly spend is greater than 100' do
      expect(described_class.eligible_for_free_coffee?).to eq true
    end
  end

  context 'with .sixty_days_after_first_spend' do
    it 'returns all last 60 days created transaction after the first transaction' do
      ids = described_class.sixty_days_after_first_spend.pluck(:id)
      expect(ids).to match_array [transaction1.id, transaction2.id, transaction3.id, transaction4.id]
    end
  end

  context 'with .quarterly_spend' do
    it 'returns quarterly spend' do
      first_quarter = transaction1.amount_spent + transaction2.amount_spent + transaction3.amount_spent + transaction4.amount_spent
      second_quarter = transaction5.amount_spent + transaction6.amount_spent + transaction7.amount_spent

      expect(described_class.quarterly_spend).to match_array [first_quarter, second_quarter]
    end
  end
end

RSpec.describe Transaction, 'Dynamic Scope', type: :model do
  let(:user) { create(:user) }
  let!(:transaction1) { create(:transaction, user: user, amount_spent: 20, created_at: 2.years.ago) }
  let!(:transaction2) { create(:transaction, user: user, amount_spent: 10, created_at: 1.years.ago) }
  let!(:transaction3) { create(:transaction, user: user, amount_spent: 20, created_at: 45.days.ago) }
  let!(:transaction4) { create(:transaction, user: user, amount_spent: 10, created_at: 30.days.ago) }
  let!(:transaction5) { create(:transaction, user: user, amount_spent: 5, created_at: Date.today)  }

  context 'with .last_60_days' do
    it 'returns records created 60 days ago' do
      ids = described_class.last_60_days.pluck(:id)
      expect(ids).to match_array [transaction3.id, transaction4.id, transaction5.id]
    end
  end

  context 'with .eligible_for_free_coffee?' do
    it 'returns true when any monthly spend is less than 100' do
      expect(described_class.eligible_for_free_coffee?).to eq false
    end
  end

  context 'with .non_expired' do
    it 'returns records created within last year' do
      ids = described_class.non_expired.pluck(:id)
      expect(ids).to match_array [transaction3.id, transaction4.id, transaction5.id]
    end
  end
end

RSpec.describe Transaction, 'Instance Methods', type: :model do
  let(:user) { create(:user) }
  context 'with #spend_oversea' do
    it 'returns true when transaction country is different from the user country' do
      transaction = create(:transaction, user: user, country: create(:country, code: 'au'))
      expect(transaction).to be_spent_oversea
    end

    it 'returns true when transaction country is the same as user country' do
      transaction = create(:transaction, user: user, country: user.country)
      expect(transaction).not_to be_spent_oversea
    end
  end
end
