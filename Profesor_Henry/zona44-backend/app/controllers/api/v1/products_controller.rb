module Api
  module V1
    class ProductsController < BaseController
      def index
        if params[:group_id]
          products = Product.where(group_id: params[:group_id])
        else
          products = Product.all
        end
        render json: products, include: :customizations
      end

      def show
        product = Product.find(params[:id])
        render json: product, include: :customizations
      end
    end
  end
end
