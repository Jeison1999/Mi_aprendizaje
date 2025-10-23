class Api::V1::AuthController < ApplicationController
  include ExceptionHandler
  
  # POST /api/v1/auth/login
  def login
    user = Usuario.find_by(email: params[:email])
    
    if user&.authenticate(params[:password])
      # Generar token JWT simple (sin gema externa por ahora)
      token = generate_token(user.id)
      
      render json: {
        message: 'Login exitoso',
        token: token,
        user: {
          id: user.id,
          nombre: user.nombre,
          email: user.email,
          rol: user.rol,
          asignatura: user.asignatura&.nombre
        }
      }, status: :ok
    else
      render json: {
        message: 'Credenciales inválidas'
      }, status: :unauthorized
    end
  end

  # POST /api/v1/auth/logout
  def logout
    # Con JWT, el logout se maneja del lado del cliente eliminando el token
    render json: {
      message: 'Logout exitoso'
    }, status: :ok
  end

  # POST /api/v1/auth/register
  def register
    # Solo permitir registro de instructores
    if params[:rol] != 'instructor'
      render json: {
        message: 'Solo se permite registro de instructores'
      }, status: :forbidden
      return
    end

    # Buscar la asignatura
    asignatura = Asignatura.find_by(id: params[:asignatura_id])
    unless asignatura
      render json: {
        message: 'Asignatura no encontrada'
      }, status: :not_found
      return
    end

    user = Usuario.new(
      nombre: params[:nombre],
      email: params[:email],
      password: params[:password],
      password_confirmation: params[:password_confirmation],
      rol: 'instructor',
      asignatura: asignatura
    )

    if user.save
      token = generate_token(user.id)
      render json: {
        message: 'Usuario creado exitosamente',
        token: token,
        user: {
          id: user.id,
          nombre: user.nombre,
          email: user.email,
          rol: user.rol,
          asignatura: user.asignatura.nombre
        }
      }, status: :created
    else
      render json: {
        message: 'Error al crear usuario',
        errors: user.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  # GET /api/v1/auth/me
  def me
    if current_user
      render json: {
        user: {
          id: current_user.id,
          nombre: current_user.nombre,
          email: current_user.email,
          rol: current_user.rol,
          asignatura: current_user.asignatura&.nombre
        }
      }, status: :ok
    else
      render json: {
        message: 'Usuario no autenticado'
      }, status: :unauthorized
    end
  end

  private

  def generate_token(user_id)
    # Token simple basado en Base64 (para desarrollo)
    # En producción usar JWT real
    payload = {
      user_id: user_id,
      exp: 24.hours.from_now.to_i
    }
    Base64.encode64(payload.to_json)
  end
end
