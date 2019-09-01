class Reward < ApplicationRecord
  AWARDS = {
    free_coffee: 'Free Coffee'.freeze,
    cash_rebate: '5% Cash Rebate'.freeze,
    free_movie_tickets: 'Free Movie Tickets'.freeze,
    airport_lounge_access: '4x Airport Lounge Access Reward'.freeze
  }.freeze

  class << self
    AWARDS.each do |key, value|
      define_method "#{key}" do
        find_by(name: value)
      end
    end
  end
end
