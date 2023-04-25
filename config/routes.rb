# frozen_string_literal: true

Rails.application.routes.draw do
  root "home#index"

  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  devise_scope :user do
    get "login", to: "devise/sessions#new"
    get "register", to: "devise/registrations#new"
    delete "logout", to: "devise/sessions#destroy"
    get "settings", to: "devise/registrations#edit"
  end

  get "users/:id", to: "users#show", as: "user"
end
