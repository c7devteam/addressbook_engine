Rails.application.routes.draw do
  mount Addressbook::Engine => "/addressbook"

  get "/register", to: "accounts#new", as: :account_register

  resources :accounts
  resources :sessions, only: [:create]
  get "login", to: "sessions#new", as: :account_login
  get "logout", to: "sessions#destroy", as: :account_logout

  root "addressbook/address_book#index"

end
