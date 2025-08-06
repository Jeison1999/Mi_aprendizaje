class Api::ProductosController < ApplicationController
  before_action :set_producto, only: [:show, :update, :destroy]
  skip_before_action :autorizar_usuario, only: [:index, :show]

  def index
    productos = Producto.all.includes(:grupo)
    render json: productos.map { |p| producto_response(p) }
  end

  def show
    render json: producto_response(@producto)
  end

  def create
    return render json: { error: "Solo admins" }, status: :unauthorized unless usuario_actual&.admin?

    producto = Producto.new(producto_params)
    producto.imagen.attach(params[:imagen]) if params[:imagen].present?

    if producto.save
      render json: producto_response(producto), status: :created
    else
      render json: { errors: producto.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    return render json: { error: "Solo admins" }, status: :unauthorized unless usuario_actual&.admin?

    @producto.assign_attributes(producto_params)
    @producto.imagen.attach(params[:imagen]) if params[:imagen].present?

    if @producto.save
      render json: producto_response(@producto)
    else
      render json: { errors: @producto.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    return render json: { error: "Solo admins" }, status: :unauthorized unless usuario_actual&.admin?

    @producto.destroy
    head :no_content
  end

  private

  def set_producto
    @producto = Producto.find(params[:id])
  end

  def producto_params
    params.permit(:nombre, :descripcion, :precio, :grupo_id)
  end

  def producto_response(producto)
    {
      id: producto.id,
      nombre: producto.nombre,
      descripcion: producto.descripcion,
      precio: producto.precio,
      grupo_id: producto.grupo_id,
      imagen_url: producto.imagen.attached? ? url_for(producto.imagen) : nil
    }
  end
end
