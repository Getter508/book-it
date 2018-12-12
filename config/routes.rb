Rails.application.routes.draw do
  devise_for :users

  resources :books
  resources :to_read_books, only: [:index, :create, :update, :destroy]
  resources :have_read_books, only: [:index, :create, :update, :destroy]

  post 'have_read_books/create_or_update', to: 'have_read_books#create_or_update'
  post 'have_read_books/update_date', to: 'have_read_books#update_date'

  root to: 'books#index'

  namespace :api do
    namespace :v1 do
      resources :have_read_books, only: [:create, :update]
    end
  end
end
