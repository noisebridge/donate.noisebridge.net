require 'sidekiq/web'

Sidekiq::Web.use Rack::Auth::Basic do |username, password|
  ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(username), ::Digest::SHA256.hexdigest(Rails.application.secrets.sidekiq_web_username)) &
    ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(password), ::Digest::SHA256.hexdigest(Rails.application.secrets.sidekiq_web_password))
end if Rails.env.production?

Rails.application.routes.draw do
  root 'donations#index'

  get '/thanks', to: 'donations#thanks'

  resources :projects, only: [:show, :index]

  scope :donations do
    resource :subscriptions, only: [:create]
    resource :charges, only: [:create]
  end

  namespace :api do
    resource :stripe_events, only: [:create]
    resource :paypal_notifications, only: [:create]
  end

  mount Sidekiq::Web, at: "/sidekiq"
end
