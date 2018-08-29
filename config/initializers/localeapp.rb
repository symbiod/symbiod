require 'localeapp/rails'

Localeapp.configure do |config|
  config.api_key = ENV['LOCALEAPP_API_KEY']
  config.sending_environments = []
  config.polling_environments = []
  config.reloading_environments = []
end
