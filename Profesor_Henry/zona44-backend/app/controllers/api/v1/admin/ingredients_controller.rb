module Api
  module V1
    module Admin
      class IngredientsController < ApplicationController
        before_action :authorize_request

        def index
          ingredients = Ingredient.all
          render json: ingredients, status: :ok
        end

        def create
          ingredient = Ingredient.new(ingredient_params)

          if ingredient.save
            render json: ingredient, status: :created
          else
            render json: { errors: ingredient.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def update
          ingredient = Ingredient.find(params[:id])

          if ingredient.update(ingredient_params)
            render json: ingredient
          else
            render json: { errors: ingredient.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def destroy
          Ingredient.find(params[:id]).destroy
          render json: { message: 'Ingrediente eliminado' }
        end

        private

        def ingredient_params
          params.permit(:name, :image_url, :is_available, prices_by_size: {})
        end
      end
    end
  end
end 