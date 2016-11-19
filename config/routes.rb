Rails.application.routes.draw do
  # Api definition
  namespace :api, defaults: { format: :json } do
    namespace :v1, path: '/' do
      resources :sessions, only: [:create, :destroy]
      resources :invitations, only: :create
      resources :mentors, only: [:create, :update]
      resources :organizations, only: [:create, :update]
      resources :users, only: [:index, :show, :destroy] do
        get :me, on: :collection
      end
    end
  end
end
