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

  context '#rewards' do
    context 'when eligible for free coffee' do
      it 'returns free coffee' do
        allow(Transaction).to receive_message_chain(:monthly_spend, :eligible_for_free_coffee?).and_return(true)
        expect(user.rewards).to be_include 'Free Coffee'
      end
    end

    context 'when user birthday month is the same as current month' do
      it 'returns free coffee' do
        user.date_of_birth = Date.current

        expect(user.rewards).to be_include 'Free Coffee'
      end
    end

    context 'when total spend is greater than 100' do
      it 'returns 5% Cash Rebate' do
        allow(Transaction).to receive(:total_spend).and_return(200)

        expect(user.rewards).to be_include '5% Cash Rebate'
      end
    end

    context 'when total spend is less than 100' do
      it 'returns 5% Cash Rebate' do
        allow(Transaction).to receive(:total_spend).and_return(90)

        expect(user.rewards).not_to be_include '5% Cash Rebate'
      end
    end

    context 'when last sixty day spend is greater than 1000' do
      it 'returns free movie tickets' do
        allow(Transaction).to receive_message_chain(:sixty_days_after_first_spend, :total_spend).and_return(1_100)

        expect(user.rewards).to be_include 'Free Movie Tickets'
      end
    end

    context 'when last sixty day spend is less than 1000' do
      it 'returns free movie tickets' do
        allow(Transaction).to receive_message_chain(:sixty_days_after_first_spend, :total_spend).and_return(900)

        expect(user.rewards).not_to be_include 'Free Movie Tickets'
      end
    end

    context 'when user tier is gold' do
      it 'returns 4x Airport Lounge Access Reward' do
        allow(user).to receive(:tier).and_return(User::GOLD_TIER)

        expect(user.rewards).to be_include '4x Airport Lounge Access Reward'
      end
    end

    context 'when user tier is standard' do
      it 'returns 4x Airport Lounge Access Reward' do
        allow(user).to receive(:tier).and_return(User::STANDARD_TIER)

        expect(user.rewards).not_to be_include '4x Airport Lounge Access Reward'
      end
    end
  end

  context '#tier' do
    context 'standard' do
      it 'returns standard when total point is 0' do
        allow(subject).to receive(:total_point).and_return(0)

        expect(subject.tier).to eq User::STANDARD_TIER
      end

      it 'returns standard when total point is less than 1000' do
        allow(subject).to receive(:total_point).and_return(900)

        expect(subject.tier).to eq User::STANDARD_TIER
      end
    end

    context 'gold' do
      it 'returns gold when total point is 1000' do
        allow(subject).to receive(:total_point).and_return(1_000)

        expect(subject.tier).to eq User::GOLD_TIER
      end

      it 'returns gold when total point is less than 5000' do
        allow(subject).to receive(:total_point).and_return(3_000)

        expect(subject.tier).to eq User::GOLD_TIER
      end
    end

    context 'platinum' do
      it 'returns platinum when total point is 5000' do
        allow(subject).to receive(:total_point).and_return(5_000)

        expect(subject.tier).to eq User::PLATINUM_TIER
      end

      it 'returns platinum when total point is greater than 5000' do
        allow(subject).to receive(:total_point).and_return(6_000)

        expect(subject.tier).to eq User::PLATINUM_TIER
      end
    end
  end
end
