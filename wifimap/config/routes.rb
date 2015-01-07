Rails.application.routes.draw do
  root :to => 'pages#index'

  resources :access_points do
    resources :signal_samples
  end

  namespace :api do
    namespace :v1 do
      post "add" => "access_points_api#create_or_update"
    end
  end
end
