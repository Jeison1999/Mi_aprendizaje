class AsignacionFicha < ApplicationRecord
  self.table_name = 'asignacion_fichas'
  
  # Relaciones
  belongs_to :instructor, class_name: 'Usuario', foreign_key: 'instructorid'
  belongs_to :ficha, foreign_key: 'fichaid'
  has_many :asistencias, foreign_key: 'asignacionid', dependent: :destroy
  
  # Delegaciones
  delegate :asignatura, to: :instructor
  delegate :nombre, to: :instructor, prefix: true
  delegate :codigo, :nombre, to: :ficha, prefix: true
  
  # Validaciones
  validates :instructorid, presence: true
  validates :fichaid, presence: true
  validates :instructorid, uniqueness: { scope: :fichaid, 
                                          message: 'ya está asignado a esta ficha' }
  
  validate :instructor_debe_tener_rol_instructor
  validate :instructor_debe_tener_asignatura
  
  # Métodos
  def tomar_asistencia(fecha, aprendiz_id, estado)
    # Validar que el aprendiz pertenezca a la ficha
    unless ficha.aprendizs.exists?(aprendiz_id)
      return { error: "El aprendiz no pertenece a esta ficha" }
    end
    
    asistencias.create(
      fecha: fecha,
      aprendizid: aprendiz_id,
      estado: estado
    )
  end
  
  def ver_asistencias(fecha = nil)
    if fecha
      asistencias.where(fecha: fecha).includes(:aprendiz)
    else
      asistencias.includes(:aprendiz)
    end
  end
  
  def asignatura_nombre
    instructor.asignatura&.nombre
  end
  
  private
  
  def instructor_debe_tener_rol_instructor
    if instructor.present? && instructor.rol != 'instructor'
      errors.add(:instructor, 'debe tener rol de instructor')
    end
  end
  
  def instructor_debe_tener_asignatura
    if instructor.present? && instructor.asignatura_id.nil?
      errors.add(:instructor, 'debe tener una asignatura asignada')
    end
  end
end
