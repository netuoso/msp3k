Rails.application.routes.draw do
  devise_for :users
  resources :users
  resources :permissions

  get :users, controller: :home, action: :users

  root controller: :home, action: :index
end
