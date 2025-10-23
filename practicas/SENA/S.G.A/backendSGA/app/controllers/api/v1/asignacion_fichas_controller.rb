class Api::V1::AsignacionFichasController < ApplicationController
  include ExceptionHandler
  
  before_action :authenticate_user!
  before_action :ensure_admin!
  
  # GET /api/v1/asignacion_fichas
  def index
    asignaciones = AsignacionFicha.includes(:ficha, :instructor)
    
    render json: {
      asignaciones: asignaciones.map do |asignacion|
        {
          id: asignacion.id,
          ficha: {
            id: asignacion.ficha.id,
            numero: asignacion.ficha.numero,
            programa: asignacion.ficha.programa
          },
          instructor: {
            id: asignacion.instructor.id,
            nombre: asignacion.instructor.nombre,
            email: asignacion.instructor.email,
            asignatura: asignacion.instructor.asignatura&.nombre
          },
          created_at: asignacion.created_at
        }
      end
    }, status: :ok
  end
  
  # POST /api/v1/asignacion_fichas
  def create
    ficha = Ficha.find(params[:ficha_id])
    instructor = Usuario.instructores.find(params[:instructor_id])
    
    # Verificar que el instructor no esté ya asignado a esta ficha
    if AsignacionFicha.exists?(ficha: ficha, instructor: instructor)
      render json: {
        message: 'El instructor ya está asignado a esta ficha'
      }, status: :unprocessable_entity
      return
    end
    
    asignacion = AsignacionFicha.new(
      ficha: ficha,
      instructor: instructor
    )
    
    if asignacion.save
      render json: {
        message: 'Ficha asignada exitosamente',
        asignacion: {
          id: asignacion.id,
          ficha: {
            id: asignacion.ficha.id,
            numero: asignacion.ficha.numero,
            programa: asignacion.ficha.programa
          },
          instructor: {
            id: asignacion.instructor.id,
            nombre: asignacion.instructor.nombre,
            email: asignacion.instructor.email
          }
        }
      }, status: :created
    else
      render json: {
        message: 'Error al asignar ficha',
        errors: asignacion.errors.full_messages
      }, status: :unprocessable_entity
    end
  end
  
  # DELETE /api/v1/asignacion_fichas/:id
  def destroy
    asignacion = AsignacionFicha.find(params[:id])
    
    if asignacion.destroy
      render json: {
        message: 'Asignación eliminada exitosamente'
      }, status: :ok
    else
      render json: {
        message: 'Error al eliminar asignación',
        errors: asignacion.errors.full_messages
      }, status: :unprocessable_entity
    end
  end
  
  private
  
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
