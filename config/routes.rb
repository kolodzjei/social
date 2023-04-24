# frozen_string_literal: true

Rails.application.routes.draw do
  root "home#index"

  devise_for :users

  devise_scope :user do
    get "login", to: "devise/sessions#new"
    get "register", to: "devise/registrations#new"
    delete "logout", to: "devise/sessions#destroy"
  end
end
