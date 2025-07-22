module Api
  module V1
    class OrdersController < ApplicationController
      before_action :authorize_request

      def create
        order = current_user.orders.new(order_params)
        order.status = :pendiente # Estado por defecto

        if order.save
          # Soportar items enviados como root o dentro de order
          items = params[:items] || items_params
          if items.present?
            items.each do |item|
              order.order_items.create!(
                product_id: item[:product_id],
                quantity: item[:quantity],
                subtotal: item[:subtotal]
              )
            end
            # Transmitir pedido al canal de ActionCable
            ActionCable.server.broadcast("orders_channel", {
              id: order.id,
              status: order.status,
              total: order.total,
              user_id: order.user_id,
              created_at: order.created_at,
              items: order.order_items.as_json(
                include: {
                  product: {
                    only: [:id, :name, :description, :price, :image_url]
                  }
                },
                only: [:product_id, :quantity, :subtotal]
              )
            })
          end
          render json: { message: "Pedido creado exitosamente", order_id: order.id }, status: :created
        else
          render json: { errors: order.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def index
        orders = current_user.orders
        orders = orders.where(status: params[:status]) if params[:status].present?
        orders = orders.order(created_at: :desc).includes(order_items: :product)

        render json: orders.as_json(
          include: {
            order_items: {
              include: {
                product: {
                  only: [:id, :name, :description, :price, :image_url]
                }
              },
              only: [:quantity, :subtotal]
            }
          },
          only: [:id, :total, :status, :created_at]
        ), status: :ok
      end

      def cancel
        order = current_user.orders.find_by(id: params[:id])

        if order.nil?
          return render json: { error: "Pedido no encontrado" }, status: :not_found
        end

        if order.status != "pendiente"
          return render json: { error: "Solo se pueden cancelar pedidos pendientes" }, status: :unprocessable_entity
        end

        order.update(status: "cancelado")
        render json: { message: "Pedido cancelado exitosamente", order_id: order.id }, status: :ok
      end


      def show
        order = current_user.orders.includes(order_items: :product).find_by(id: params[:id])

        if order
          render json: order.as_json(
            include: {
              order_items: {
                include: {
                  product: {
                    only: [:id, :name, :description, :price, :image_url]
                  }
                },
                only: [:quantity, :subtotal]
              }
            },
            only: [:id, :total, :status, :created_at]
          )
        else
          render json: { error: "Pedido no encontrado" }, status: :not_found
        end
      end

      private

      def order_params
        params.require(:order).permit(:total, :order_type, :delivery_address, :phone)
      end

      def items_params
        params.require(:order).permit(items: [:product_id, :quantity, :price])[:items]
      end
    end
  end
end
