class Api::AdicionalsController < ApplicationController
  skip_before_action :autorizar_usuario, only: [:index]

  def index
    adicionales = Adicional.all
    render json: adicionales
  end

  def create
    return render json: { error: 'Solo admins' }, status: :unauthorized unless usuario_actual.admin?

    adicional = Adicional.new(adicional_params)
    if adicional.save
      render json: adicional, status: :created
    else
      render json: { errors: adicional.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def adicional_params
    params.permit(:nombre, :precio, :imagen)
  end
end
