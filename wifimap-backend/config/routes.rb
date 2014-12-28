Rails.application.routes.draw do
  resources :nodes

  namespace :api do
    resources :nodes
  end
end
