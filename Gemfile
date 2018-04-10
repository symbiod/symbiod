source 'https://rubygems.org'

git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '~> 2.5.0'

gem 'rails', '5.2.0.rc2'
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.11'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'haml-rails'

gem 'aasm'
gem 'trailblazer-operation'
gem 'sorcery'
gem 'simple_form'
gem 'reform'
gem 'reform-rails'
gem 'dry-validation'
gem 'sidekiq'
gem 'slack-ruby-client'

# Rails 5.2 stuff
# gem 'mini_magick', '~> 4.8'
#gem 'bootsnap', '>= 1.1.0', require: false

group :development, :test do
  gem 'pry-rails'
  gem 'rspec-rails'
  gem 'rspec-its'
  gem 'factory_bot_rails'
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
end

group :development do
  gem 'migration_opener'
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'rubocop'
end

group :test do
  gem 'faker'
  gem 'shoulda-matchers'
  gem 'database_cleaner'
  gem 'webmock'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
