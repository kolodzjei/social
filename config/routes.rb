# frozen_string_literal: true

Rails.application.routes.draw do
  root "home#index"

  devise_for :users,
    controllers: { omniauth_callbacks: "users/omniauth_callbacks", registrations: "users/registrations" }

  devise_scope :user do
    get "login", to: "devise/sessions#new"
    get "register", to: "devise/registrations#new"
    delete "logout", to: "devise/sessions#destroy"
    get "settings", to: "devise/registrations#edit"
  end

  get "users/:id", to: "users#show", as: "user"
  get "users/:id/followers", to: "users#followers", as: "followers"
  get "users/:id/following", to: "users#following", as: "following"

  resources :likes, only: [:create, :destroy]
  resources :posts, only: [:create, :destroy, :show]
  resources :comments, only: [:create, :destroy, :show]
  resources :replies, only: [:create, :destroy]
  post "follow", to: "relationships#create", as: "follow"
  delete "unfollow", to: "relationships#destroy", as: "unfollow"
end
