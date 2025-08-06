class ApplicationController < ActionController::API
  before_action :autorizar_usuario

  private

  # Verifica si hay un token de autorización válido y decodifica el JWT.
  def autorizar_usuario
    header = request.headers["Authorization"]
    token = header&.split&.last

    if token.present?
      begin
        decoded = JWT.decode(token, Rails.application.credentials.secret_key_base)[0]
        @usuario_actual = Usuario.find(decoded["usuario_id"])
      rescue JWT::DecodeError, ActiveRecord::RecordNotFound => e
        render json: { error: "No autorizado", mensaje: e.message }, status: :unauthorized
      end
    else
      render json: { error: "Token no proporcionado" }, status: :unauthorized
    end
  end

  # Método helper que expone el usuario actual autenticado.
  def usuario_actual
    @usuario_actual
  end
end
