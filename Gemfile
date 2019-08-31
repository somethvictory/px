source 'https://rubygems.org'

ruby '2.3.0'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.0.7'
gem 'sqlite3', '~> 1.3.13'
gem 'puma', '~> 3.0'

group :development, :test do
  gem 'pry'
  gem 'rspec-rails'
  gem 'factory_bot_rails'
end

group :development do
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
