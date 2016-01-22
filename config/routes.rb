Rails.application.routes.draw do
  root 'donations#index'

  get '/thanks', to: 'donations#thanks'
  get '/projects/:project', to: 'donations#project'

  scope :donations do
    resource :subscriptions, only: [:create]
    resource :charges, only: [:create]
  end
end
