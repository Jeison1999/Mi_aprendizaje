module Api
  module V1
    class GroupsController < BaseController
      skip_before_action :authorize_request
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
