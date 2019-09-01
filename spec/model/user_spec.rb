require 'rails_helper'

RSpec.describe User, 'Validations', type: :model do
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:date_of_birth) }
end

RSpec.describe User, 'Associations', type: :model do
  it { is_expected.to belong_to(:country) }
  it { is_expected.to have_many(:transactions) }
end

RSpec.describe User, 'Instance Method', type: :model do
  let(:user) { create(:user) }
  let!(:transaction1) { create(:transaction, user: user, country: user.country, amount_spent: 20, created_at: 2.years.ago) }
  let!(:transaction2) { create(:transaction, user: user, country: user.country, amount_spent: 40, created_at: 1.years.ago) }
  let!(:transaction3) { create(:transaction, user: user, country: user.country, amount_spent: 70, created_at: 45.days.ago) }
  let!(:transaction4) { create(:transaction, user: user, country: user.country, amount_spent: 80, created_at: 30.days.ago) }
  let!(:transaction5) { create(:transaction, user: user, country: user.country, amount_spent: 20, created_at: 10.days.ago)  }

  context 'without oversea transaction, #total_point' do
    it 'calculates all non expired transactions' do
      expected_point = ((transaction3.amount_spent + transaction4.amount_spent + transaction5.amount_spent) / Transaction::ELIGIBLE_SPEND).to_i * 10
      expect(user.total_point).to eq expected_point
    end
  end

  context 'with oversea transaction, #total_point' do
    let!(:transaction6) { create(:transaction, user: user, amount_spent: 150, created_at: 10.days.ago)  }
    let!(:transaction7) { create(:transaction, user: user, amount_spent: 40, created_at: 10.days.ago)  }
    it 'calculates all non expired transactions' do
      expected_point = ((transaction3.amount_spent + transaction4.amount_spent + transaction5.amount_spent) / Transaction::ELIGIBLE_SPEND).to_i * 10
      expected_point += ((transaction6.amount_spent + transaction7.amount_spent) / Transaction::ELIGIBLE_SPEND).to_i * 10 * 2
      expect(user.total_point).to eq expected_point
    end
  end

  context '#birthday_month?' do
    it 'returns true when the user birthday month is the same as current month' do
      user = create(:user, date_of_birth: Date.today)

      expect(user.birthday_month?).to eq true
    end

    it 'returns false when the user birthday month is not the same as current month' do
      user = create(:user, date_of_birth: 2.month.ago)

      expect(user.birthday_month?).to eq false
    end
  end
end
