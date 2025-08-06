class Api::GruposController < ApplicationController
  skip_before_action :autorizar_usuario, only: [:index, :show]

  def index
    grupos = Grupo.includes(:productos).all
    render json: grupos.as_json(include: :productos)
  end

  def show
    grupo = Grupo.includes(:productos).find(params[:id])
    render json: grupo.as_json(include: :productos)
  end

  def create
    return render json: { error: 'Solo admins' }, status: :unauthorized unless usuario_actual.admin?

    grupo = Grupo.new(grupo_params)
    if grupo.save
      render json: grupo, status: :created
    else
      render json: { errors: grupo.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def grupo_params
    params.permit(:nombre, :imagen)
  end
end
