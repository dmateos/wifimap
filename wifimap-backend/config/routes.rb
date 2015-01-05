Rails.application.routes.draw do
  resources :locations

  devise_for :users
  root :to => 'pages#index'

  resources :nodes, :locations

  namespace :api do
    resources :nodes
  end
end
