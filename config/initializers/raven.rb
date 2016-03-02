Raven.configure do |config|
  next unless Rails.env.production?
  config.dsn = Rails.application.secrets.dsn_url
  config.environments = ['production']
end
