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
  {name: 'Jugger', country: 'sg', date_of_birth: '1999-09-30'},
  {name: 'Riki', country: 'sg', date_of_birth: '1987-11-09'},
  {name: 'Tinker', country: 'sg', date_of_birth: '1900-04-13'}
]
users.each do |user|
  User.find_or_create_by(name: user[:name], country: Country.find_by(code: user[:country]), date_of_birth: user[:date_of_birth])
end
