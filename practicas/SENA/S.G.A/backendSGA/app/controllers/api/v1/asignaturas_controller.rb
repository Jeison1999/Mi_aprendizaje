class Api::V1::AsignaturasController < ApplicationController
  include ExceptionHandler
  
  before_action :authenticate_user!
  before_action :ensure_admin!, except: [:index]
  
  # GET /api/v1/asignaturas (público para registro de instructores)
  def index
    asignaturas = Asignatura.all
    
    render json: {
      asignaturas: asignaturas.map do |asignatura|
        {
          id: asignatura.id,
          nombre: asignatura.nombre,
          instructores_count: asignatura.usuarios.count
        }
      end
    }, status: :ok
  end
  
  # POST /api/v1/asignaturas
  def create
    asignatura = Asignatura.new(asignatura_params)
    
    if asignatura.save
      render json: {
        message: 'Asignatura creada exitosamente',
        asignatura: {
          id: asignatura.id,
          nombre: asignatura.nombre
        }
      }, status: :created
    else
      render json: {
        message: 'Error al crear asignatura',
        errors: asignatura.errors.full_messages
      }, status: :unprocessable_entity
    end
  end
  
  # PUT /api/v1/asignaturas/:id
  def update
    asignatura = Asignatura.find(params[:id])
    
    if asignatura.update(asignatura_params)
      render json: {
        message: 'Asignatura actualizada exitosamente',
        asignatura: {
          id: asignatura.id,
          nombre: asignatura.nombre
        }
      }, status: :ok
    else
      render json: {
        message: 'Error al actualizar asignatura',
        errors: asignatura.errors.full_messages
      }, status: :unprocessable_entity
    end
  end
  
  # DELETE /api/v1/asignaturas/:id
  def destroy
    asignatura = Asignatura.find(params[:id])
    
    # Verificar que no tenga instructores asignados
    if asignatura.usuarios.any?
      render json: {
        message: 'No se puede eliminar la asignatura porque tiene instructores asignados'
      }, status: :unprocessable_entity
      return
    end
    
    if asignatura.destroy
      render json: {
        message: 'Asignatura eliminada exitosamente'
      }, status: :ok
    else
      render json: {
        message: 'Error al eliminar asignatura',
        errors: asignatura.errors.full_messages
      }, status: :unprocessable_entity
    end
  end
  
  private
  
  def asignatura_params
    params.permit(:nombre)
  end
  
  def authenticate_user!
    token = request.headers['Authorization']&.split(' ')&.last
    return render json: { message: 'Token no proporcionado' }, status: :unauthorized unless token
    
    begin
      payload = JSON.parse(Base64.decode64(token))
      @current_user = Usuario.find(payload['user_id'])
    rescue => e
      render json: { message: 'Token inválido' }, status: :unauthorized
    end
  end
  
  def ensure_admin!
    unless @current_user&.admin?
      render json: { message: 'Acceso denegado. Solo administradores.' }, status: :forbidden
    end
  end
  
  def current_user
    @current_user
  end
end
