require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq' if Rails.env.development?
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  devise_for :users
  root to: 'posts#index'

  resource :timeline, only: [:show]

  resource :profile, only: [:show, :edit, :update]

  resources :accounts, only: [:show] do
    resources :follows, only: [:show, :create]
    resources :unfollows, only: [:create]

    resources :followings, only: [:index]
    resources :followers, only: [:index]
  end

  resources :posts, only: [:index, :show, :new, :create] do
    resource :like, only: [:show, :create, :destroy]
    resources :comments, shallow: true, only: [:index, :create, :destroy]
  end
end
