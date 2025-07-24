module Api
  module V1
    class GroupsController < BaseController
      def index
        groups = Group.all.with_attached_image
        render json: groups
      end

      def show
        group = Group.find(params[:id])
        render json: group
      end
    end
  end
end
