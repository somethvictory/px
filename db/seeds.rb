# Rewards
rewards = ['Free Coffee', '5% Cash Rebate', 'Free Movie Tickets', '4x Airport Lounge Access Reward']

rewards.each do |reward|
  Reward.find_or_create_by(name: reward)
end

# Countries
countries = [
  {name: 'Singapore', code: 'sg'},
  {name: 'United States', code: 'us'},
  {name: 'United Kingdom', code: 'uk'},
  {name: 'Australia', code: 'au'}
]
countries.each do |country|
  Country.find_or_create_by(name: country[:name], code: country[:code])
end

# Users
users = [
  {name: 'Lina', country: 'sg', date_of_birth: '2000-10-12'},
  {name: 'Void', country: 'sg', date_of_birth: '1986-08-01'},
  {name: 'Jugger', country: 'us', date_of_birth: '1999-09-30'},
  {name: 'Riki', country: 'sg', date_of_birth: '1987-11-09'},
  {name: 'Tinker', country: 'au', date_of_birth: '1900-04-13'}
]
users.each do |user|
  User.find_or_create_by(name: user[:name], country: Country.find_by(code: user[:country]), date_of_birth: user[:date_of_birth])
end

# Transactions
transactions = [
  {user_name: 'Lina', amount_spent: 20, country: 'sg', created_at: '2019-01-01 00:00:00', updated_at: '2019-01-01 00:00:00'},
  {user_name: 'Void', amount_spent: 14, country: 'sg', created_at: '2019-01-01 00:00:00', updated_at: '2019-01-01 00:00:00'},
  {user_name: 'Jugger', amount_spent: 82, country: 'sg', created_at: '2019-01-01 00:00:00', updated_at: '2019-01-01 00:00:00'},
  {user_name: 'Riki', amount_spent: 12, country: 'sg', created_at: '2019-01-01 00:00:00', updated_at: '2019-01-01 00:00:00'},
  {user_name: 'Tinker', amount_spent: 21, country: 'au', created_at: '2019-01-01 00:00:00', updated_at: '2019-01-01 00:00:00'},
  {user_name: 'Lina', amount_spent: 12, country: 'sg', created_at: '2019-02-01 00:00:00', updated_at: '2019-02-01 00:00:00'},
  {user_name: 'Void', amount_spent: 23, country: 'sg', created_at: '2019-02-01 00:00:00', updated_at: '2019-02-01 00:00:00'},
  {user_name: 'Jugger', amount_spent: 32, country: 'sg', created_at: '2019-02-01 00:00:00', updated_at: '2019-02-01 00:00:00'},
  {user_name: 'Riki', amount_spent: 5, country: 'sg', created_at: '2019-01-02 00:00:00', updated_at: '2019-02-01 00:00:00'},
  {user_name: 'Tinker', amount_spent: 8, country: 'au', created_at: '2019-02-01 00:00:00', updated_at: '2019-02-01 00:00:00'},
  {user_name: 'Lina', amount_spent: 2, country: 'sg', created_at: '2019-03-01 00:00:00', updated_at: '2019-03-01 00:00:00'},
  {user_name: 'Void', amount_spent: 31, country: 'sg', created_at: '2019-03-01 00:00:00', updated_at: '2019-03-01 00:00:00'},
  {user_name: 'Jugger', amount_spent: 43, country: 'sg', created_at: '2019-03-01 00:00:00', updated_at: '2019-03-01 00:00:00'},
  {user_name: 'Riki', amount_spent: 21, country: 'sg', created_at: '2019-01-03 00:00:00', updated_at: '2019-01-03 00:00:00'},
  {user_name: 'Tinker', amount_spent: 7, country: 'au', created_at: '2019-03-01 00:00:00', updated_at: '2019-03-01 00:00:00'},
  {user_name: 'Lina', amount_spent: 42, country: 'sg', created_at: '2019-04-01 00:00:00', updated_at: '2019-04-01 00:00:00'},
  {user_name: 'Void', amount_spent: 18, country: 'sg', created_at: '2019-04-01 00:00:00', updated_at: '2019-04-01 00:00:00'},
  {user_name: 'Jugger', amount_spent: 19, country: 'sg', created_at: '2019-04-01 00:00:00', updated_at: '2019-04-01 00:00:00'},
  {user_name: 'Riki', amount_spent: 87, country: 'sg', created_at: '2019-01-04 00:00:00', updated_at: '2019-01-04 00:00:00'},
  {user_name: 'Tinker', amount_spent: 63, country: 'au', created_at: '2019-04-01 00:00:00', updated_at: '2019-04-01 00:00:00'}
]
transactions.each do |transaction|
  Transaction.find_or_create_by(
    user: User.find_by(name: transaction[:user_name]),
    amount_spent: transaction[:amount_spent],
    country: Country.find_by(code: transaction[:country]),
    created_at: transaction[:created_at],
    created_at: transaction[:updated_at]
  )
end
