class User < ApplicationRecord
  STANDARD_POINT = 10
  STANDARD_TIER  = 'standard_tier'.freeze
  GOLD_TIER      = 'gold_tier'.freeze
  PLATINUM_TIER  = 'platinum_tier'.freeze

  validates :name,          presence: true
  validates :date_of_birth, presence: true

  belongs_to :country

  has_many   :transactions

  def total_point
    return @total_point if @total_point

    @total_point = 0
    local_spend  = 0
    oversea_spend = 0

    transactions.non_expired.each do |transaction|
      if transaction.spent_oversea?
        oversea_spend += transaction.amount_spent
      else
        local_spend   += transaction.amount_spent
      end
    end

    @total_point = ((oversea_spend / Transaction::ELIGIBLE_SPEND).to_i * STANDARD_POINT * 2 ) + (local_spend / Transaction::ELIGIBLE_SPEND).to_i * STANDARD_POINT
  end

  def birthday_month?
    date_of_birth.month == Date.current.month
  end

  def rewards
    return @rewards if @rewards
    @rewards = []
    @rewards << Reward.free_coffee if transactions.grouped_by_month.eligible_for_free_coffee?
    @rewards << Reward.free_coffee if birthday_month?
    @rewards << Reward.cash_rebate if transactions.size >= 10 || transactions.total_spend > Transaction::ELIGIBLE_SPEND
    @rewards << Reward.free_movie_tickets if transactions.sixty_days_after_first_spend.total_spend > Transaction::FREE_TICKET_MOVIE_SPEND
    @rewards << Reward.airport_lounge_access if tier == GOLD_TIER

    @rewards
  end

  def tier
    if total_point == 0 && total_point < 1_000
      STANDARD_TIER
    elsif  total_point > 1_000 && total_point < 5_000
      GOLD_TIER
    elsif total_point > 5_000
      PLATINUM_TIER
    end
  end
end
