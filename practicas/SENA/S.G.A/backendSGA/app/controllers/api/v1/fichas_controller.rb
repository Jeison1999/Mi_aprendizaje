class Api::V1::FichasController < ApplicationController
  include ExceptionHandler
  
  before_action :authenticate_user!
  before_action :ensure_admin!, except: [:index, :show]
  
  # GET /api/v1/fichas
  def index
    fichas = Ficha.includes(:aprendizs, :asignacion_fichas)
    
    # Si es instructor, solo mostrar sus fichas asignadas
    if current_user.instructor?
      fichas = current_user.fichas.includes(:aprendizs)
    end
    
    render json: {
      fichas: fichas.map do |ficha|
        {
          id: ficha.id,
          codigo: ficha.codigo,
          nombre: ficha.nombre,
          aprendices_count: ficha.aprendizs.count,
          instructores: ficha.asignacion_fichas.map do |asignacion|
            {
              id: asignacion.instructor.id,
              nombre: asignacion.instructor.nombre,
              asignatura: asignacion.instructor.asignatura&.nombre
            }
          end
        }
      end
    }, status: :ok
  end
  
  # GET /api/v1/fichas/:id
  def show
    ficha = Ficha.includes(:aprendizs, :asignacion_fichas).find(params[:id])
    
    # Si es instructor, verificar que tenga acceso a esta ficha
    if current_user.instructor? && !current_user.fichas.include?(ficha)
      render json: { message: 'No tienes acceso a esta ficha' }, status: :forbidden
      return
    end
    
    render json: {
      ficha: {
        id: ficha.id,
codigo: ficha.codigo,
            nombre: ficha.nombre,
        fecha_inicio: ficha.fecha_inicio,
        fecha_fin: ficha.fecha_fin,
        aprendices: ficha.aprendizs.map do |aprendiz|
          {
            id: aprendiz.id,
            nombre: aprendiz.nombre,
            documento: aprendiz.documento,
            telefono: aprendiz.telefono,
            email: aprendiz.email
          }
        end,
        instructores: ficha.asignacion_fichas.map do |asignacion|
          {
            id: asignacion.instructor.id,
            nombre: asignacion.instructor.nombre,
            asignatura: asignacion.instructor.asignatura&.nombre
          }
        end
      }
    }, status: :ok
  end
  
  # POST /api/v1/fichas
  def create
    ficha = Ficha.new(ficha_params)
    
    if ficha.save
      render json: {
        message: 'Ficha creada exitosamente',
        ficha: {
          id: ficha.id,
codigo: ficha.codigo,
            nombre: ficha.nombre,
          fecha_inicio: ficha.fecha_inicio,
          fecha_fin: ficha.fecha_fin
        }
      }, status: :created
    else
      render json: {
        message: 'Error al crear ficha',
        errors: ficha.errors.full_messages
      }, status: :unprocessable_entity
    end
  end
  
  # PUT /api/v1/fichas/:id
  def update
    ficha = Ficha.find(params[:id])
    
    if ficha.update(ficha_params)
      render json: {
        message: 'Ficha actualizada exitosamente',
        ficha: {
          id: ficha.id,
codigo: ficha.codigo,
            nombre: ficha.nombre,
          fecha_inicio: ficha.fecha_inicio,
          fecha_fin: ficha.fecha_fin
        }
      }, status: :ok
    else
      render json: {
        message: 'Error al actualizar ficha',
        errors: ficha.errors.full_messages
      }, status: :unprocessable_entity
    end
  end
  
  # DELETE /api/v1/fichas/:id
  def destroy
    ficha = Ficha.find(params[:id])
    
    if ficha.destroy
      render json: {
        message: 'Ficha eliminada exitosamente'
      }, status: :ok
    else
      render json: {
        message: 'Error al eliminar ficha',
        errors: ficha.errors.full_messages
      }, status: :unprocessable_entity
    end
  end
  
  private
  
  def ficha_params
    params.permit(:codigo, :nombre)
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
