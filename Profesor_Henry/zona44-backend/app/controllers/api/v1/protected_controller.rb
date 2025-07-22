module Api
  module V1
    class ProtectedController < ApplicationController
      def index
        render json: { message: "Hola, #{@current_user.name}. Estás autenticado como #{@current_user.role}." }
      end
    end
  end
end
