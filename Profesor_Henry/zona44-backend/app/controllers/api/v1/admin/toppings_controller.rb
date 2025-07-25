module Api
  module V1
    module Admin
      class ToppingsController < ApplicationController
        before_action :authorize_request

        def index
          render json: Topping.all
        end

        def create
          topping = Topping.new(topping_params)
          if topping.save
            render json: topping, status: :created
          else
            render json: { errors: topping.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def destroy
          Topping.find(params[:id]).destroy
          render json: { message: 'Topping eliminado' }
        end

        private

        def topping_params
          params.permit(:name, :price)
        end
      end
    end
  end
end
