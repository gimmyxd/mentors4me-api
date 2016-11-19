Rails.application.routes.draw do
  devise_for :users
  # Api definition
  namespace :api, defaults: { format: :json } do
    namespace :v1, path: '/' do
      resources :sessions, only: [:create, :destroy]
      resources :skills
      resources :invitations, only: :create do
        post :reject, on: :collection
      end
      resources :mentors, only: [:create, :update] do
        post :propose, on: :collection
      end
      resources :organizations, only: [:create, :update]
      resources :users, only: [:index, :show, :destroy] do
        get :me, on: :collection
      end
    end
  end
end
