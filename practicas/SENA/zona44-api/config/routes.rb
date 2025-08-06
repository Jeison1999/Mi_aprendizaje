Rails.application.routes.draw do
 namespace :api do
    post   'registro', to: 'auth#register'
    post   'login',    to: 'auth#login'
    get    'perfil',   to: 'auth#perfil'
    post 'payu/pagar', to: 'payu#pagar'

    resources :grupos, only: [:index, :show, :create, :update, :destroy]
    resources :productos, only: [:index, :show, :create, :update, :destroy]
    resources :tamano_pizzas, only: [:index]
    resources :adicionals, only: [:index, :create]

    namespace :payu do
      get 'formulario', to: 'pagos#formulario'
      post 'notificacion', to: 'pagos#notificacion'
    end
  end
end
