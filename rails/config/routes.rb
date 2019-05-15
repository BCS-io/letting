Letting::Application.routes.draw do
  get 'arrears/index'

  resources :sessions, only: %i[create destroy]
  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'
  get '/404', to: 'errors#not_found'
  get '/422', to: 'errors#server_error'
  get '/500', to: 'errors#server_error'

  get 'search' => 'search#index', as: :search

  resources :search_suggestions, only: [:index]

  root 'properties#index'
  resources :arrears, only: [:index]
  resources :client_payments, only: [:show]
  resources :clients do
    member do
      patch :payments_itemized
    end
  end
  resources :guides, only: %i[index show edit update]
  resources :payments
  resources :payments_by_dates, only: %i[index destroy]
  resources :properties, path: 'accounts'
  resources :invoicings
  resources :invoice_texts, only: %i[index show edit update]
  resources :invoices, only: [:show]
  resources :print_invoices, only: [:show]
  resources :print_runs, only: [:show]
  resources :property_lists, only: [:index]
  resources :runs, only: %i[show destroy]
  resources :second_runs_needed, only: %i[index destroy]

  # Admin
  resources :cycles
  resources :users
end
