class Api::V1::InstructoresController < ApplicationController
  include ExceptionHandler
  
  before_action :authenticate_user!
  before_action :ensure_admin!
  
  # GET /api/v1/instructores
  def index
    instructores = Usuario.instructores.includes(:asignatura)
    
    render json: {
      instructores: instructores.map do |instructor|
        {
          id: instructor.id,
          nombre: instructor.nombre,
          email: instructor.email,
          asignatura: instructor.asignatura&.nombre,
          fichas_asignadas: instructor.fichas.count,
          created_at: instructor.created_at
        }
      end
    }, status: :ok
  end
  
  # GET /api/v1/instructores/:id
  def show
    instructor = Usuario.instructores.find(params[:id])
    
    render json: {
      instructor: {
        id: instructor.id,
        nombre: instructor.nombre,
        email: instructor.email,
        asignatura: instructor.asignatura&.nombre,
        fichas: instructor.fichas.map do |ficha|
          {
            id: ficha.id,
            numero: ficha.numero,
            programa: ficha.programa,
            aprendices_count: ficha.aprendizs.count
          }
        end,
        created_at: instructor.created_at
      }
    }, status: :ok
  end
  
  # PUT /api/v1/instructores/:id
  def update
    instructor = Usuario.instructores.find(params[:id])
    
    if instructor.update(instructor_params)
      render json: {
        message: 'Instructor actualizado exitosamente',
        instructor: {
          id: instructor.id,
          nombre: instructor.nombre,
          email: instructor.email,
          asignatura: instructor.asignatura&.nombre
        }
      }, status: :ok
    else
      render json: {
        message: 'Error al actualizar instructor',
        errors: instructor.errors.full_messages
      }, status: :unprocessable_entity
    end
  end
  
  # DELETE /api/v1/instructores/:id
  def destroy
    instructor = Usuario.instructores.find(params[:id])
    
    if instructor.destroy
      render json: {
        message: 'Instructor eliminado exitosamente'
      }, status: :ok
    else
      render json: {
        message: 'Error al eliminar instructor',
        errors: instructor.errors.full_messages
      }, status: :unprocessable_entity
    end
  end
  
  private
  
  def instructor_params
    params.permit(:nombre, :email, :asignatura_id)
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
