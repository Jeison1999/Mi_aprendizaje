module Authenticable
  extend ActiveSupport::Concern

  def current_user
    @current_user ||= Usuario.find(decoded_auth_token[:user_id]) if decoded_auth_token
  rescue ActiveRecord::RecordNotFound => e
    raise ExceptionHandler::InvalidToken, "Token inválido: #{e.message}"
  end

  def user_logged_in?
    !!current_user
  end

  private

  def http_auth_header
    if request.headers['Authorization'].present?
      return request.headers['Authorization'].split(' ').last
    end
    raise ExceptionHandler::MissingToken, 'Token de autorización no encontrado'
  end

  def decoded_auth_token
    @decoded_auth_token ||= JwtService.decode(http_auth_header)
  end
end
