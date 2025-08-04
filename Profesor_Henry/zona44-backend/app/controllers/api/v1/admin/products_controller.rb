module Api
  module V1
    module Admin
      class ProductsController < ApplicationController
        before_action :authorize_request
        before_action :authorize_admin
        before_action :set_product, only: [ :show, :update, :destroy ]

        # GET /api/v1/admin/products
        def index
          @products = Product.includes(image_attachment: :blob).all
          render json: @products.map { |p| serialize_product(p) }
        end

        # GET /api/v1/admin/products/:id
        def show
          render json: serialize_product(@product)
        end

        # POST /api/v1/admin/products
        def create
          @product = Product.new(product_params)
          @product.image.attach(params[:image]) if params[:image].present?

          if @product.save
            render json: serialize_product(@product), status: :created
          else
            render json: { errors: @product.errors.full_messages }, status: :unprocessable_entity
          end
        end

        # PUT /api/v1/admin/products/:id
        def update
          if @product.update(product_params)
            @product.image.purge if params[:image].present?
            @product.image.attach(params[:image]) if params[:image].present?
            render json: serialize_product(@product)
          else
            render json: { errors: @product.errors.full_messages }, status: :unprocessable_entity
          end
        end

        # DELETE /api/v1/admin/products/:id
        def destroy
          @product.destroy
          head :no_content
        end

        private

        def set_product
          @product = Product.find(params[:id])
        rescue ActiveRecord::RecordNotFound
          render json: { error: "Producto no encontrado" }, status: :not_found
        end

        def product_params
          params.permit(:name, :description, :price, :group_id, :image)
        end

        def serialize_product(product)
          {
            id: product.id,
            name: product.name,
            description: product.description,
            price: product.price,
            group_id: product.group_id,
            image_url: product.image.attached? ? url_for(product.image) : nil
          }
        end

        def authorize_admin
          unless current_user&.admin?
            render json: { error: "Acceso denegado" }, status: :forbidden
          end
        end
      end
    end
  end
end
