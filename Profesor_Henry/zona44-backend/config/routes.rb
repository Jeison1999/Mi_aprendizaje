Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      # Auth
      post "/register", to: "auth#register"
      post "/login", to: "auth#login"
      get "profile", to: "users#profile"

      # Recursos públicos
      resources :groups, only: [ :index, :show ]
      resources :products, only: [ :index, :show ]

      # Pedidos del cliente
      resources :orders, only: [ :create, :show, :index ] do
        member do
          put :cancel
        end
      end

      # Ruta protegida de prueba
      get "protected", to: "protected#index"

      # 👇 Rutas del panel de administrador
      namespace :admin do
        resources :pizza_bases
        resources :pizza_sizes
        resources :ingredients
        resources :pizza_variants, only: [ :create, :update, :destroy ]
        resources :toppings, only: [ :index, :create, :destroy ]
        resources :crust_options, only: [ :index, :create, :destroy ]
        resources :pizza_combinations, only: [ :index, :create, :destroy ]
        resources :groups, only: [ :index, :show, :create, :update, :destroy ]
        resources :products, only: [ :index, :create, :update, :destroy, :show ]
        resources :orders, only: [ :index, :show, :update, :destroy ] do
          member do
          end
        end
      end
    end
  end
end
