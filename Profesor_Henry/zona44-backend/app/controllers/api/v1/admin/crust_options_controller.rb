module Api
  module V1
    module Admin
      class CrustOptionsController < ApplicationController
        before_action :authorize_request
        before_action :authorize_admin

        def index
          render json: CrustOption.all
        end

        def create
          crust = CrustOption.new(crust_params)
          if crust.save
            render json: crust, status: :created
          else
            render json: { errors: crust.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def destroy
          CrustOption.find(params[:id]).destroy
          render json: { message: 'Borde eliminado' }
        end

        private

        def crust_params
          params.permit(:size, :price)
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
