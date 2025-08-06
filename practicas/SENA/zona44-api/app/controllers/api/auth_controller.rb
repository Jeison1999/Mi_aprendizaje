class Api::AuthController < ApplicationController
  skip_before_action :autorizar_usuario
  # POST /api/registro
  def register
    usuario = Usuario.new(usuario_params)
    if usuario.save
      token = generar_token(usuario)
      render json: { usuario: usuario_response(usuario), token: token }, status: :created
    else
      render json: { errors: usuario.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # POST /api/login
  def login
    usuario = Usuario.find_by(email: params[:email])
    if usuario&.authenticate(params[:password])
      token = generar_token(usuario)
      render json: { usuario: usuario_response(usuario), token: token }
    else
      render json: { error: 'Credenciales inválidas' }, status: :unauthorized
    end
  end

  # GET /api/perfil
  def perfil
    usuario = usuario_actual
    render json: usuario_response(usuario)
  end

  private

  def usuario_params
    params.permit(:nombre, :email, :password, :rol)
  end

  def usuario_response(usuario)
    {
      id: usuario.id,
      nombre: usuario.nombre,
      email: usuario.email,
      rol: usuario.rol
    }
  end

  def generar_token(usuario)
    payload = { usuario_id: usuario.id }
    JWT.encode(payload, Rails.application.secrets.secret_key_base)
  end

  def usuario_actual
    cabecera = request.headers['Authorization']
    token = cabecera.split.last rescue nil
    decoded = JWT.decode(token, Rails.application.secrets.secret_key_base)[0]
    Usuario.find(decoded["usuario_id"])
  rescue
    nil
  end
end
