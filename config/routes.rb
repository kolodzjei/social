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

  resources :users, only: [:show] do
    member do
      get :following, :followers
    end
  end

  post "like", to: "likes#create"
  delete "like", to: "likes#destroy"

  resources :posts, only: [:create, :destroy, :show] do
    resources :likes, only: [:create], module: :posts
    delete "likes", to: "posts/likes#destroy"
  end

  resources :comments, only: [:create, :destroy, :show]
  resources :replies, only: [:create, :destroy, :show]
  post "follow", to: "relationships#create", as: "follow"
  delete "unfollow", to: "relationships#destroy", as: "unfollow"
end
