module Api
  module V1
    module Admin
      class OrdersController < ApplicationController
        before_action :authorize_request
        before_action :authorize_admin
        before_action :set_order, only: [:show, :update]

        # GET /api/v1/admin/orders
        def index
          if params[:status].present?
            @orders = Order.where(status: params[:status])
          else
            @orders = Order.all
          end

          render json: @orders.as_json(include: {
            order_items: { include: :product }
          })
        end

        # GET /api/v1/admin/orders/:id
        def show
          render json: @order.as_json(include: {
            order_items: { include: :product }
          })
        end

        # PUT /api/v1/admin/orders/:id
        def update
          if @order.update(order_params)
            render json: { message: "Pedido actualizado", order: @order }
          else
            render json: { error: @order.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def update_status
          order = Order.find(params[:id])
          new_status = params[:status]

          if Order.statuses.keys.include?(new_status)
            order.update(status: new_status)
            render json: { message: "Estado actualizado a #{new_status}", order_id: order.id }
          else
            render json: { error: "Estado inválido" }, status: :unprocessable_entity
          end
        end

        private

        def authorize_admin
          unless @current_user && @current_user.admin?
            render json: { error: "Acceso denegado: Solo administradores" }, status: :unauthorized
          end
        end

        def set_order
          @order = Order.find(params[:id])
        end

        def order_params
          params.require(:order).permit(:status)
        end
      end
    end
  end
end
