Rails.application.routes.draw do
  root :to => 'nodes#index'

  resources :nodes

  namespace :api do
    resources :nodes
  end
end
