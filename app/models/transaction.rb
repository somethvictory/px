class Transaction < ApplicationRecord
  ELIGIBLE_SPEND = 100
  FREE_TICKET_MOVIE_SPEND = 1_000
  ELIGIBLE_QUARTERLY_SPEND = 2_000
  QUARTERLY_BONUS_POINT = 100

  validates :amount_spent, presence: true

  belongs_to :user
  belongs_to :country

  scope :total_spend,   -> { sum(:amount_spent) }
  scope :last_60_days,  -> { where('created_at > ?', 60.days.ago) }
  scope :monthly_spend, -> { select("sum(amount_spent) as monthly_spend, strftime('%m', created_at) as month").group(:month) }
  scope :non_expired,   -> { where('created_at > ?', 1.year.ago) }

  def self.eligible_for_free_coffee?
    monthly_spend.any? do |transaction|
      transaction.monthly_spend > ELIGIBLE_SPEND
    end
  end

  def self.sixty_days_after_first_spend
    first_transaction = order(:created_at).first
    where('created_at > ? and created_at < ?', first_transaction, first_transaction.created_at + 60.days)
  end

  def self.quarterly_spend
    spend = []
    monthly_spend.each_slice(3) do |months|
      quarter_spend = 0
      months.each do |month|
        quarter_spend += month.monthly_spend
      end
      spend << quarter_spend
    end
    spend
  end

  def spent_oversea?
    user.country != country
  end
end
