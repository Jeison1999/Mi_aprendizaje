class Api::ProductosController < ApplicationController
  skip_before_action :autorizar_usuario, only: [:index, :show]

  def index
    productos = Producto.includes(:precios_por_tamano, :adicionales).all
    render json: productos.as_json(include: [:precios_por_tamano, :adicionales])
  end

  def show
    producto = Producto.includes(:precios_por_tamano, :adicionales).find(params[:id])
    render json: producto.as_json(include: [:precios_por_tamano, :adicionales])
  end

  def create
    return render json: { error: 'Solo admins' }, status: :unauthorized unless usuario_actual.admin?

    producto = Producto.new(producto_params)
    if producto.save
      render json: producto, status: :created
    else
      render json: { errors: producto.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def producto_params
    params.permit(:nombre, :descripcion, :imagen, :grupo_id)
  end
end
