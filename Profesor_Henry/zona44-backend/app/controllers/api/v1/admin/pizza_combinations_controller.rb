module Api
  module V1
    module Admin
      class PizzaCombinationsController < ApplicationController
        before_action :authorize_request

        def index
          render json: PizzaCombination.all
        end

        def create
          combo = PizzaCombination.new(combo_params)
          if combo.save
            render json: combo, status: :created
          else
            render json: { errors: combo.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def destroy
          PizzaCombination.find(params[:id]).destroy
          render json: { message: 'Combinación eliminada' }
        end

        private

        def combo_params
          params.permit(:pizza_base1_id, :pizza_base2_id, :size, :price)
        end
      end
    end
  end
end
