# frozen_string_literal: true
Rails.application.routes.draw do
  # apipie documentation endpoint
  apipie

  # devise
  devise_for :users

  # Serve websocket cable requests in-process
  mount ActionCable.server => '/cable'

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
          put :activate
          put :deactivate
        end
      end
      resources :mentors, only: [:index, :show, :create, :update, :destroy] do
        member do
          put :password
          put :activate
          put :deactivate
        end
      end
      resources :organizations, only: [:index, :show, :create, :update, :destroy] do
        member do
          put :password
          put :activate
          put :deactivate
        end
      end

      post '/contact', to: 'contacts#create'
    end
  end
end
