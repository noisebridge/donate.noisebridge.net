Sidekiq.configure_server do |config| 
  redis_url = if Rails.env.production?
    ENV['REDIS_URL']
  else
    "redis://#{ENV['DOCKER_REDIS_HOST']}:#{ENV['DOCKER_REDIS_PORT']}/1"
  end
  config.redis = {
    url: redis_url
  }
end
