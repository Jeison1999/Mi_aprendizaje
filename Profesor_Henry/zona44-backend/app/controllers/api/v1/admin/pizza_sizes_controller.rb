module Api
  module V1
    module Admin
      class PizzaSizesController < ApplicationController
        before_action :authorize_request
        before_action :authorize_admin

        def index
          sizes = PizzaSize.all
          render json: sizes, status: :ok
        end

        def create
          size = PizzaSize.new(pizza_size_params)

          if size.save
            render json: size, status: :created
          else
            render json: { errors: size.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def update
          size = PizzaSize.find(params[:id])

          if size.update(pizza_size_params)
            render json: size
          else
            render json: { errors: size.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def destroy
          PizzaSize.find(params[:id]).destroy
          render json: { message: 'Tamaño eliminado' }
        end

        private

        def pizza_size_params
          params.permit(:name, :slices, :diameter, :base_price)
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