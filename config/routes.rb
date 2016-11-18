Rails.application.routes.draw do
  devise_for :users, path: 'api', only: [:invitations],
                     controllers: { invitations: 'api/v1/invitations' }

  # Api definition
  namespace :api, defaults: { format: :json } do
    namespace :v1, path: '/' do
      resources :sessions, only: [:create, :destroy]
      resources :invitations, only: :create
      resources :users, only: [:index, :show, :create, :destroy] do
        get :me, on: :collection
        post :create_mentor, on: :collection
      end
    end
  end
end
