class Api::GruposController < ApplicationController
  skip_before_action :autorizar_usuario, only: [ :index, :show ]

  include Rails.application.routes.url_helpers  # Necesario para url_for()

  def index
    grupos = Grupo.includes(:productos).all
    render json: grupos.map { |g| grupo_response(g) }
  end

  def show
    grupo = Grupo.includes(:productos).find(params[:id])
    render json: grupo_response(grupo, incluir_productos: true)
  end

  def create
    return render json: { error: "Solo admins" }, status: :unauthorized unless usuario_actual&.admin?

    grupo = Grupo.new(nombre: params[:nombre])
    grupo.imagen.attach(params[:imagen]) if params[:imagen].present?

    if grupo.save
      render json: grupo_response(grupo), status: :created
    else
      render json: { errors: grupo.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    grupo = Grupo.find(params[:id])

    return render json: { error: "Solo admins" }, status: :unauthorized unless usuario_actual&.admin?

    grupo.nombre = params[:nombre] if params[:nombre].present?
    grupo.imagen.attach(params[:imagen]) if params[:imagen].present?

    if grupo.save
      render json: grupo_response(grupo)
    else
      render json: { errors: grupo.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    grupo = Grupo.find(params[:id])

    return render json: { error: "Solo admins" }, status: :unauthorized unless usuario_actual&.admin?

    grupo.destroy
    render json: { mensaje: "Grupo eliminado correctamente" }, status: :ok
  end




  private

  def grupo_params
    params.permit(:nombre, :imagen)
  end

  def grupo_response(grupo, incluir_productos: false)
    data = {
      id: grupo.id,
      nombre: grupo.nombre,
      imagen_url: grupo.imagen.attached? ? url_for(grupo.imagen) : nil
    }

    if incluir_productos
      data[:productos] = grupo.productos.map do |p|
        {
          id: p.id,
          nombre: p.nombre,
          descripcion: p.descripcion,
          precio: p.precio
          # Puedes incluir más campos si quieres
        }
      end
    end

    data
  end
end
