# app/controllers/api/v1/admin/pizza_bases_controller.rb
module Api
  module V1
    module Admin
      class PizzaBasesController < ApplicationController
        before_action :authorize_request

        def index
          pizzas = PizzaBase.includes(:pizza_variants, :toppings, image_attachment: :blob).all
          render json: pizzas, status: :ok
        end

        def create
          pizza = PizzaBase.new(pizza_params)
          pizza.image.attach(params[:image]) if params[:image]

          if pizza.save
            render json: pizza, status: :created
          else
            render json: { errors: pizza.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def update
          pizza = PizzaBase.find(params[:id])
          pizza.image.attach(params[:image]) if params[:image]

          if pizza.update(pizza_params)
            render json: pizza
          else
            render json: { errors: pizza.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def destroy
          PizzaBase.find(params[:id]).destroy
          render json: { message: 'Pizza eliminada' }
        end

        private

        def pizza_params
          params.permit(
            :name,
            :description,
            :category,
            :has_cheese_border,
            :cheese_border_price,
            topping_ids: [],
            pizza_variants_attributes: [:size, :price]
          )
        end
      end
    end
  end
end
