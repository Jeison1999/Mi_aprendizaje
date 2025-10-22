class Asignatura < ApplicationRecord
  self.table_name = 'asignaturas'
  
  # Relaciones
  has_many :asignacion_ficha_instructors, foreign_key: 'asignaturaid'
  has_many :fichas, through: :asignacion_ficha_instructors
  has_many :instructores, through: :asignacion_ficha_instructors, source: :instructor
  
  # Validaciones
  validates :nombre, presence: true, uniqueness: true
end
