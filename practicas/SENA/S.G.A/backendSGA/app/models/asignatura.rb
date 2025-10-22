class Asignatura < ApplicationRecord
  self.table_name = 'asignaturas'
  
  # Relaciones
  has_many :usuarios, dependent: :restrict_with_error  # Instructores que enseñan esta asignatura
  has_many :instructores, -> { where(rol: 'instructor') }, class_name: 'Usuario'
  
  # Validaciones
  validates :nombre, presence: true, uniqueness: true
  
  # Métodos
  def total_instructores
    instructores.count
  end
end
