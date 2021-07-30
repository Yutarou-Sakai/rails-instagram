Rails.application.routes.draw do
  devise_for :users
  root to: 'home#index'

  resource :profile, only: [:show, :edit, :update]
  resources :accounts, only: [:update]
end
