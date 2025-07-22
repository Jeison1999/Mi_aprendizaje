module Api
  module V1
    class AuthController < ApplicationController
      skip_before_action :authorize_request, only: [:login, :register]
      def register
        user = User.new(user_params)

        if user.save
          token = jwt_encode(user_id: user.id)
          render json: { token: token, user: user.as_json(only: [:id, :name, :email, :role]) }, status: :created
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def login
        user = User.find_by(email: params[:email])
        if user && user.valid_password?(params[:password])
          token = jwt_encode(user_id: user.id)
          render json: { token: token, user: user.as_json(only: [:id, :name, :email, :role]) }, status: :ok
        else
          render json: { error: 'Credenciales inválidas' }, status: :unauthorized
        end
      end

      private

      def user_params
        params.require(:user).permit(:name, :email, :password, :role)
      end

      def jwt_encode(payload, exp = 24.hours.from_now)
        payload[:exp] = exp.to_i
        JWT.encode(payload, Rails.application.credentials.secret_key_base)
      end
    end
  end
end
