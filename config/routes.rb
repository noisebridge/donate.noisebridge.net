Rails.application.routes.draw do
  get 'errors/file_not_found'

  get 'errors/unprocessable'

  get 'errors/internal_server_error'

  root 'donations#index'

  get '/thanks', to: 'donations#thanks'

  get '/recurring', to: 'donations#recurring'

  get '/dues', to: 'donations#dues'

  scope :donations do
    resource :subscriptions, only: [:create]
    resource :charges, only: [:create]
  end

  match '/404', to: 'errors#file_not_found', via: :all
  match '/422', to: 'errors#unprocessable', via: :all
  match '/500', to: 'errors#internal_server_error', via: :all
end
