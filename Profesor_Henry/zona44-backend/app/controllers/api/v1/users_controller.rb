module Api
  module V1
    class UsersController < ApplicationController
      def profile
        render json: current_user
      end
    end
  end
end
