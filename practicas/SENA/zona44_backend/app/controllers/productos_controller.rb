class ProductosController < ApplicationController
  before_action :authenticate_usuario!, except: [:index, :show]
  before_action :set_producto, only: [:show, :update, :destroy]

  def index
    productos = Producto.all
    render json: productos
  end

  def show
    render json: @producto
  end

  def create
    return head :forbidden unless current_usuario&.role == 'admin'
    producto = Producto.new(producto_params)
    if producto.save
      render json: producto, status: :created
    else
      render json: producto.errors, status: :unprocessable_entity
    end
  end

  def update
    return head :forbidden unless current_usuario&.role == 'admin'
    if @producto.update(producto_params)
      render json: @producto
    else
      render json: @producto.errors, status: :unprocessable_entity
    end
  end

  def destroy
    return head :forbidden unless current_usuario&.role == 'admin'
    @producto.destroy
    head :no_content
  end

  private
    def set_producto
      @producto = Producto.find(params[:id])
    end

    def producto_params
      params.require(:producto).permit(:nombre, :descripcion, :precio, :grupo_id)
    end
end
