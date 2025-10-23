class Api::V1::AsistenciasController < ApplicationController
  include ExceptionHandler
  
  before_action :authenticate_user!
  before_action :ensure_instructor_or_admin!
  
  # GET /api/v1/asistencias
  def index
    fecha = params[:fecha] || Date.current.to_s
    fichas_ids = current_user.instructor? ? current_user.fichas.pluck(:id) : Ficha.pluck(:id)
    
    asistencias = Asistencia.where(fecha: fecha, ficha_id: fichas_ids)
                           .includes(:aprendiz, :ficha)
    
    render json: {
      fecha: fecha,
      asistencias: asistencias.map do |asistencia|
        {
          id: asistencia.id,
          aprendiz: {
            id: asistencia.aprendiz.id,
            nombre: asistencia.aprendiz.nombre,
            documento: asistencia.aprendiz.documento
          },
          ficha: {
            id: asistencia.ficha.id,
            numero: asistencia.ficha.numero,
            programa: asistencia.ficha.programa
          },
          presente: asistencia.presente,
          observaciones: asistencia.observaciones,
          created_at: asistencia.created_at
        }
      end
    }, status: :ok
  end
  
  # POST /api/v1/asistencias
  def create
    fecha = params[:fecha] || Date.current.to_s
    ficha = Ficha.find(params[:ficha_id])
    
    # Verificar que el instructor tenga acceso a esta ficha
    if current_user.instructor? && !current_user.fichas.include?(ficha)
      render json: { message: 'No tienes acceso a esta ficha' }, status: :forbidden
      return
    end
    
    # Crear asistencias para todos los aprendices de la ficha
    asistencias_creadas = []
    errores = []
    
    ficha.aprendizs.each do |aprendiz|
      # Verificar si ya existe asistencia para este aprendiz en esta fecha
      existing_asistencia = Asistencia.find_by(
        aprendiz: aprendiz,
        ficha: ficha,
        fecha: fecha
      )
      
      if existing_asistencia
        errores << "Ya existe asistencia para #{aprendiz.nombre} en la fecha #{fecha}"
        next
      end
      
      asistencia = Asistencia.new(
        aprendiz: aprendiz,
        ficha: ficha,
        fecha: fecha,
        presente: params[:aprendices]&.find { |a| a[:id] == aprendiz.id }&.dig(:presente) || false,
        observaciones: params[:aprendices]&.find { |a| a[:id] == aprendiz.id }&.dig(:observaciones) || ''
      )
      
      if asistencia.save
        asistencias_creadas << {
          id: asistencia.id,
          aprendiz: {
            id: asistencia.aprendiz.id,
            nombre: asistencia.aprendiz.nombre,
            documento: asistencia.aprendiz.documento
          },
          presente: asistencia.presente,
          observaciones: asistencia.observaciones
        }
      else
        errores << "Error al crear asistencia para #{aprendiz.nombre}: #{asistencia.errors.full_messages.join(', ')}"
      end
    end
    
    if asistencias_creadas.any?
      render json: {
        message: 'Asistencias registradas exitosamente',
        fecha: fecha,
        asistencias_creadas: asistencias_creadas,
        errores: errores
      }, status: :created
    else
      render json: {
        message: 'No se pudieron crear las asistencias',
        errores: errores
      }, status: :unprocessable_entity
    end
  end
  
  # PUT /api/v1/asistencias/:id
  def update
    asistencia = Asistencia.find(params[:id])
    
    # Verificar que el instructor tenga acceso a esta asistencia
    if current_user.instructor? && !current_user.fichas.include?(asistencia.ficha)
      render json: { message: 'No tienes acceso a esta asistencia' }, status: :forbidden
      return
    end
    
    if asistencia.update(asistencia_params)
      render json: {
        message: 'Asistencia actualizada exitosamente',
        asistencia: {
          id: asistencia.id,
          aprendiz: {
            id: asistencia.aprendiz.id,
            nombre: asistencia.aprendiz.nombre,
            documento: asistencia.aprendiz.documento
          },
          presente: asistencia.presente,
          observaciones: asistencia.observaciones,
          fecha: asistencia.fecha
        }
      }, status: :ok
    else
      render json: {
        message: 'Error al actualizar asistencia',
        errors: asistencia.errors.full_messages
      }, status: :unprocessable_entity
    end
  end
  
  # GET /api/v1/asistencias/reporte
  def reporte
    fecha_inicio = params[:fecha_inicio] || Date.current.beginning_of_month.to_s
    fecha_fin = params[:fecha_fin] || Date.current.end_of_month.to_s
    fichas_ids = current_user.instructor? ? current_user.fichas.pluck(:id) : Ficha.pluck(:id)
    
    asistencias = Asistencia.where(
      fecha: fecha_inicio..fecha_fin,
      ficha_id: fichas_ids
    ).includes(:aprendiz, :ficha)
    
    # Agrupar por ficha y calcular estadísticas
    reporte_por_ficha = {}
    
    fichas_ids.each do |ficha_id|
      ficha = Ficha.find(ficha_id)
      asistencias_ficha = asistencias.where(ficha_id: ficha_id)
      
      reporte_por_ficha[ficha_id] = {
        ficha: {
          id: ficha.id,
          numero: ficha.numero,
          programa: ficha.programa
        },
        total_clases: asistencias_ficha.select(:fecha).distinct.count,
        aprendices: ficha.aprendizs.map do |aprendiz|
          asistencias_aprendiz = asistencias_ficha.where(aprendiz: aprendiz)
          presentes = asistencias_aprendiz.where(presente: true).count
          total = asistencias_aprendiz.count
          porcentaje = total > 0 ? (presentes.to_f / total * 100).round(2) : 0
          
          {
            id: aprendiz.id,
            nombre: aprendiz.nombre,
            documento: aprendiz.documento,
            presentes: presentes,
            ausentes: total - presentes,
            total: total,
            porcentaje_asistencia: porcentaje
          }
        end
      }
    end
    
    render json: {
      periodo: {
        fecha_inicio: fecha_inicio,
        fecha_fin: fecha_fin
      },
      reporte: reporte_por_ficha.values
    }, status: :ok
  end
  
  private
  
  def asistencia_params
    params.permit(:presente, :observaciones)
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
  
  def ensure_instructor_or_admin!
    unless @current_user&.instructor? || @current_user&.admin?
      render json: { message: 'Acceso denegado. Solo instructores y administradores.' }, status: :forbidden
    end
  end
  
  def current_user
    @current_user
  end
end
