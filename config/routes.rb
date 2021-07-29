Rails.application.routes.draw do
  devise_for :users
  root to: 'home#index'

  resource :profile, only: [:show, :edit, :update] do
    resource :accounts, only: [:update]
  end
end
