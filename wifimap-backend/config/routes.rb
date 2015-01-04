Rails.application.routes.draw do
  devise_for :users
  root :to => 'pages#index'

  resources :nodes

  namespace :api do
    resources :nodes
  end
end
