Rails.application.routes.draw do
  devise_for :users
  devise_scope :user do
    get '/users/sign_out', to: 'devise/sessions#destroy'
  end

  resources :books
  resources :to_read_books, only: [:index, :create, :update, :destroy]
  resources :have_read_books, only: [:index, :create, :update, :destroy]

  post 'have_read_books/create_or_update', to: 'have_read_books#create_or_update'
  post 'have_read_books/update_date', to: 'have_read_books#update_date'
  get 'have_read_books/destroy_review', to: 'have_read_books#destroy_review'

  root to: 'books#index'

  namespace :api do
    namespace :v1 do
      resources :have_read_books, only: [:create, :update]
    end
  end
end
