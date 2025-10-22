class AsignacionFichaInstructor < ApplicationRecord
  self.table_name = 'asignacion_ficha_instructors'
  
  # Relaciones
  belongs_to :instructor, class_name: 'Usuario', foreign_key: 'instructorid'
  belongs_to :asignatura, foreign_key: 'asignaturaid'
  belongs_to :ficha, foreign_key: 'fichaid'
  has_many :asistencias, foreign_key: 'asignacionid', dependent: :destroy
  
  # Validaciones
  validates :instructorid, presence: true
  validates :asignaturaid, presence: true
  validates :fichaid, presence: true
  validates :instructorid, uniqueness: { scope: [:asignaturaid, :fichaid], 
                                          message: 'ya está asignado a esta asignatura y ficha' }
  
  validate :instructor_debe_tener_rol_instructor
  
  # Métodos
  def tomar_asistencia(fecha, aprendiz_id, estado)
    asistencias.create(
      fecha: fecha,
      aprendizid: aprendiz_id,
      estado: estado
    )
  end
  
  def ver_asistencias(fecha = nil)
    if fecha
      asistencias.where(fecha: fecha)
    else
      asistencias.all
    end
  end
  
  private
  
  def instructor_debe_tener_rol_instructor
    if instructor.present? && instructor.rol != 'instructor'
      errors.add(:instructor, 'debe tener rol de instructor')
    end
  end
end
