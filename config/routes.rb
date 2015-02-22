Rails.application.routes.draw do
  root 'donations#index'

  get '/thanks', to: 'donations#thanks'

  get '/recurring', to: 'donations#recurring'

  get '/dues', to: 'donations#dues'

  scope :donations do
    resource :subscriptions, only: [:create]
    resource :charges, only: [:create]
  end
end
