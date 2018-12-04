Rails.application.routes.draw do
  devise_for :users
  resources :books
  resources :have_read_books, only: [:index, :create, :update]
  post "have_read_books/create_or_update", to: "have_read_books#create_or_update"
  post "have_read_books/update_date", to: "have_read_books#update_date"
  resources :to_read_books, only: [:index, :create, :update]
  root to: "books#index"
end
