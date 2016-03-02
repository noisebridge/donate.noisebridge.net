Raven.configure do |config|
  config.dsn = Rails.application.secrets.dsn_url
  config.environments = ['production']
end
