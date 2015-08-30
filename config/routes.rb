Rails.application.routes.draw do
  devise_for :donors
  root 'donations#index'

  get '/thanks', to: 'donations#thanks'

  scope :donations do
    resource :subscriptions, only: [:create]
    resource :charges, only: [:create]
  end
end
