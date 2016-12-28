Rails.application.routes.draw do
  apipie
  devise_for :users
  # Api definition
  namespace :api, defaults: { format: :json } do
    namespace :v1, path: '/' do
      resources :sessions, only: [:create, :destroy]
      resources :skills
      resources :proposals do
        member do
          post :accept
          post :reject
        end
      end
      resources :contexts do
        member do
          post :accept
          post :reject
        end
      end
      resources :users, only: [:index, :show, :destroy] do
        get :me, on: :collection
        member do
          put :password
        end
      end
      resources :mentors, only: [:index, :show, :create, :update]
      resources :organizations, only: [:index, :show, :create, :update]
    end
  end
end
