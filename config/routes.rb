Rails.application.routes.draw do
  root 'donations#index'

  get '/thanks', to: 'donations#thanks'

  get '/recurring', to: 'donations#recurring'

  scope :donations do
    resource :subscriptions, only: [:create]
    resource :charges, only: [:create]
  end
end
