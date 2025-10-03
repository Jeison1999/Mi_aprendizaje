class GruposController < ApplicationController
  before_action :authenticate_usuario!, except: [:index, :show]
  before_action :set_grupo, only: [:show, :update, :destroy]

  def index
    grupos = Grupo.all
    render json: grupos
  end

  def show
    render json: @grupo
  end

  def create
    return head :forbidden unless current_usuario&.role == 'admin'
    grupo = Grupo.new(grupo_params)
    if grupo.save
      render json: grupo, status: :created
    else
      render json: grupo.errors, status: :unprocessable_entity
    end
  end

  def update
    return head :forbidden unless current_usuario&.role == 'admin'
    if @grupo.update(grupo_params)
      render json: @grupo
    else
      render json: @grupo.errors, status: :unprocessable_entity
    end
  end

  def destroy
    return head :forbidden unless current_usuario&.role == 'admin'
    @grupo.destroy
    head :no_content
  end

  private
    def set_grupo
      @grupo = Grupo.find(params[:id])
    end

    def grupo_params
      params.require(:grupo).permit(:nombre, :descripcion)
    end
end
