Rails.application.routes.draw do
  root 'donations#index'

  scope :donations do
    resource :subscriptions, only: [:create]
    resource :charges, only: [:create]
  end
end
