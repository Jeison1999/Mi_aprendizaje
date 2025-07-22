Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post "/register", to: "auth#register"
      post "/login", to: "auth#login"
      get "profile", to: "users#profile"

      resources :groups, only: [:index, :show]
      resources :products, only: [:index, :show]
      resources :orders, only: [:create, :show, :index]

      get "protected", to: "protected#index"

    end
  end
end
