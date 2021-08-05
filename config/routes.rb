Rails.application.routes.draw do
  devise_for :users
  root to: 'posts#index'

  resource :profile, only: [:show, :edit, :update]

  resources :posts, only: [:index, :show, :new, :create] do
    resource :like, only: [:show, :create, :destroy]
    resources :comments, shallow: true, only: [:index, :create, :destroy]
  end
end
