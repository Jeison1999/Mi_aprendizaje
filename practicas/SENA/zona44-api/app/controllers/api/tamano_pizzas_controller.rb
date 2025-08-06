class Api::TamanoPizzasController < ApplicationController
  skip_before_action :autorizar_usuario, only: [:index]

  def index
    tamanos = TamanoPizza.all
    render json: tamanos
  end
end
