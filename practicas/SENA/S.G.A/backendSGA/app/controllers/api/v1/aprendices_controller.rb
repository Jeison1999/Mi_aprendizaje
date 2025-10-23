class Api::V1::AprendicesController < ApplicationController
  include ExceptionHandler
  
  before_action :authenticate_user!, except: [:create]
  
  # GET /api/v1/aprendices
  def index
    aprendices = Aprendiz.includes(:ficha)
    
    # Si es instructor, solo mostrar aprendices de sus fichas
    if current_user.instructor?
      fichas_ids = current_user.fichas.pluck(:id)
      aprendices = aprendices.where(ficha_id: fichas_ids)
    end
    
    render json: {
      aprendices: aprendices.map do |aprendiz|
        {
          id: aprendiz.id,
          nombre: aprendiz.nombre,
          tipodocumento: aprendiz.tipodocumento,
          ndocumento: aprendiz.ndocumento,
          correo: aprendiz.correo,
          ficha: {
            id: aprendiz.ficha.id,
            codigo: aprendiz.ficha.codigo,
            nombre: aprendiz.ficha.nombre
          },
          created_at: aprendiz.created_at
        }
      end
    }, status: :ok
  end
  
  # GET /api/v1/aprendices/:id
  def show
    aprendiz = Aprendiz.includes(:ficha).find(params[:id])
    
    # Si es instructor, verificar que tenga acceso a este aprendiz
    if current_user.instructor?
      fichas_ids = current_user.fichas.pluck(:id)
      unless fichas_ids.include?(aprendiz.ficha_id)
        render json: { message: 'No tienes acceso a este aprendiz' }, status: :forbidden
        return
      end
    end
    
    render json: {
      aprendiz: {
        id: aprendiz.id,
        nombre: aprendiz.nombre,
        documento: aprendiz.documento,
        telefono: aprendiz.telefono,
        email: aprendiz.email,
        ficha: {
          id: aprendiz.ficha.id,
          numero: aprendiz.ficha.numero,
          programa: aprendiz.ficha.programa
        },
        created_at: aprendiz.created_at
      }
    }, status: :ok
  end
  
  # POST /api/v1/aprendices (público para registro desde web)
  def create
    ficha = Ficha.find(params[:ficha_id])
    
    aprendiz = Aprendiz.new(aprendiz_params)
    aprendiz.ficha = ficha
    
    if aprendiz.save
      render json: {
        message: 'Aprendiz registrado exitosamente',
        aprendiz: {
          id: aprendiz.id,
          nombre: aprendiz.nombre,
          tipodocumento: aprendiz.tipodocumento,
          ndocumento: aprendiz.ndocumento,
          correo: aprendiz.correo,
          ficha: {
            id: aprendiz.ficha.id,
            codigo: aprendiz.ficha.codigo,
            nombre: aprendiz.ficha.nombre
          }
        }
      }, status: :created
    else
      render json: {
        message: 'Error al registrar aprendiz',
        errors: aprendiz.errors.full_messages
      }, status: :unprocessable_entity
    end
  end
  
  # PUT /api/v1/aprendices/:id
  def update
    aprendiz = Aprendiz.find(params[:id])
    
    # Si es instructor, verificar que tenga acceso a este aprendiz
    if current_user.instructor?
      fichas_ids = current_user.fichas.pluck(:id)
      unless fichas_ids.include?(aprendiz.ficha_id)
        render json: { message: 'No tienes acceso a este aprendiz' }, status: :forbidden
        return
      end
    end
    
    if aprendiz.update(aprendiz_params)
      render json: {
        message: 'Aprendiz actualizado exitosamente',
        aprendiz: {
          id: aprendiz.id,
          nombre: aprendiz.nombre,
          documento: aprendiz.documento,
          telefono: aprendiz.telefono,
          email: aprendiz.email
        }
      }, status: :ok
    else
      render json: {
        message: 'Error al actualizar aprendiz',
        errors: aprendiz.errors.full_messages
      }, status: :unprocessable_entity
    end
  end
  
  # DELETE /api/v1/aprendices/:id
  def destroy
    aprendiz = Aprendiz.find(params[:id])
    
    # Solo admin puede eliminar aprendices
    unless current_user.admin?
      render json: { message: 'Acceso denegado. Solo administradores.' }, status: :forbidden
      return
    end
    
    if aprendiz.destroy
      render json: {
        message: 'Aprendiz eliminado exitosamente'
      }, status: :ok
    else
      render json: {
        message: 'Error al eliminar aprendiz',
        errors: aprendiz.errors.full_messages
      }, status: :unprocessable_entity
    end
  end
  
  private
  
  def aprendiz_params
    params.permit(:nombre, :tipodocumento, :ndocumento, :correo, :ficha_id)
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
  
  def current_user
    @current_user
  end
end
