Rails.application.routes.draw do
  devise_for :users
  root to: 'posts#index'

  resource :profile, only: [:show, :edit, :update]
  resources :posts
end
