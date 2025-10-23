Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 flag the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # API Routes
  namespace :api do
    namespace :v1 do
      # Authentication routes
      post 'auth/login', to: 'auth#login'
      post 'auth/logout', to: 'auth#logout'
      post 'auth/register', to: 'auth#register'
      get 'auth/me', to: 'auth#me'
      
      # Recursos para admin e instructores
      resources :asignaturas, only: [:index, :create, :update, :destroy]
      resources :fichas, only: [:index, :show, :create, :update, :destroy]
      resources :aprendices, only: [:index, :show, :create, :update, :destroy]
      resources :asistencias, only: [:index, :create, :update] do
        collection do
          get 'reporte'
        end
      end
      
      # Recursos solo para admin
      resources :instructores, only: [:index, :show, :update, :destroy]
      resources :asignacion_fichas, only: [:index, :create, :destroy]
    end
  end

  # Devise routes (for web interface) - Comentado por ahora
  # devise_for :usuarios, path: 'auth', path_names: {
  #   sign_in: 'login',
  #   sign_out: 'logout',
  #   sign_up: 'register'
  # }

  # Defines the root path route ("/")
  # root "posts#index"
end
