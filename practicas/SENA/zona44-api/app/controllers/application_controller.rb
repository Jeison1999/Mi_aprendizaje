class ApplicationController < ActionController::API
  before_action :autorizar_usuario

  def autorizar_usuario
    header = request.headers['Authorization']
    token = header.split.last rescue nil

    begin
      decoded = JWT.decode(token, Rails.application.secrets.secret_key_base)[0]
      @usuario_actual = Usuario.find(decoded['usuario_id'])
    rescue
      render json: { error: 'No autorizado' }, status: :unauthorized
    end
  end

  def usuario_actual
    @usuario_actual
  end
end
