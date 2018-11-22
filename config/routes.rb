Rails.application.routes.draw do
  devise_for :users
  resources :books
  resources :have_read_books, only: [:index, :update]
  resources :to_read_books, only: [:index]
  root to: "books#index"
end
