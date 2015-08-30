Rails.application.routes.draw do
  root 'donations#index'

  get '/thanks', to: 'donations#thanks'

  scope :donations do
    resource :subscriptions, only: [:create]
    resource :charges, only: [:create]
  end

  namespace :hooks do
    resources :stripe, only: [:create]
  end
end
