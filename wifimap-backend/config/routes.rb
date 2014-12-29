Rails.application.routes.draw do
  root :to => 'pages#index'

  resources :nodes

  namespace :api do
    resources :nodes
  end
end
