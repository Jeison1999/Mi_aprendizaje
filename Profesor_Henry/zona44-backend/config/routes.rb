Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      # Auth
      post "/register", to: "auth#register"
      post "/login", to: "auth#login"
      get "profile", to: "users#profile"

      # Recursos públicos
      resources :groups, only: [:index, :show]
      resources :products, only: [:index, :show]

      # Pedidos del cliente
      resources :orders, only: [:create, :show, :index] do
        member do
          put :cancel
        end
      end

      # Ruta protegida de prueba
      get "protected", to: "protected#index"

      # 👇 Rutas del panel de administrador
      namespace :admin do
        resources :orders, only: [:index, :show, :update, :destroy] do
          member do
            put :update_status
          end
        end
      end
    end
  end
end
