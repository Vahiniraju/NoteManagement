Rails.application.routes.draw do
  get 'welcome/index'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: "sessions#destroy"
  get '/signup', to: 'users#new'
  post '/signup',  to: 'users#create'


  root 'welcome#index'
  resources :notes, except: :show
  resources :users, only: [:new, :create]
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
