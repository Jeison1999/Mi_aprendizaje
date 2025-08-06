Rails.application.routes.draw do
 namespace :api do
    post   'registro', to: 'auth#register'
    post   'login',    to: 'auth#login'
    get    'perfil',   to: 'auth#perfil'

    resources :grupos, only: [:index, :show, :create]
    resources :productos, only: [:index, :show, :create]
    resources :tamano_pizzas, only: [:index]
    resources :adicionals, only: [:index, :create]
  end
end
