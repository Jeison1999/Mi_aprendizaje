class Asistencia < ApplicationRecord
  self.table_name = 'asistencias'
  
  # Relaciones
  belongs_to :aprendiz, foreign_key: 'aprendizid'
  belongs_to :asignacion_ficha_instructor, foreign_key: 'asignacionid'
  
  # Delegaciones para facilitar acceso
  delegate :ficha, :asignatura, :instructor, to: :asignacion_ficha_instructor
  
  # Validaciones
  validates :fecha, presence: true
  validates :estado, presence: true, inclusion: { in: %w[presente ausente justificado] }
  validates :aprendizid, presence: true
  validates :asignacionid, presence: true
  validates :aprendizid, uniqueness: { scope: [:asignacionid, :fecha], 
                                        message: 'ya tiene asistencia registrada para esta fecha y asignación' }
  
  # Scopes
  scope :presentes, -> { where(estado: 'presente') }
  scope :ausentes, -> { where(estado: 'ausente') }
  scope :justificados, -> { where(estado: 'justificado') }
  scope :por_fecha, ->(fecha) { where(fecha: fecha) }
  scope :por_rango_fechas, ->(inicio, fin) { where(fecha: inicio..fin) }
  
  # Métodos
  def presente?
    estado == 'presente'
  end
  
  def ausente?
    estado == 'ausente'
  end
  
  def justificado?
    estado == 'justificado'
  end
end
