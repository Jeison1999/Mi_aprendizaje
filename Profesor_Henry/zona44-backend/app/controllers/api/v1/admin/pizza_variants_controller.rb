module Api
  module V1
    module Admin
      class PizzaVariantsController < ApplicationController
        before_action :authorize_request

        def create
          variant = PizzaVariant.new(variant_params)
          if variant.save
            render json: variant, status: :created
          else
            render json: { errors: variant.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def update
          variant = PizzaVariant.find(params[:id])
          if variant.update(variant_params)
            render json: variant
          else
            render json: { errors: variant.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def destroy
          PizzaVariant.find(params[:id]).destroy
          render json: { message: 'Tamaño eliminado' }
        end

        private

        def variant_params
          params.permit(:pizza_base_id, :size, :price)
        end
      end
    end
  end
end
