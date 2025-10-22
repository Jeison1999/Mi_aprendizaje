class Ficha < ApplicationRecord
  self.table_name = 'fichas'
  
  # Relaciones
  has_many :aprendizs, dependent: :destroy
  has_many :asignacion_fichas, foreign_key: 'fichaid', dependent: :destroy
  has_many :instructores, through: :asignacion_fichas, source: :instructor
  
  # Validaciones
  validates :codigo, presence: true, uniqueness: true
  validates :nombre, presence: true
  
  # Métodos
  def agregar_aprendiz(aprendiz_params)
    aprendizs.create(aprendiz_params)
  end
  
  # Ver instructores con sus asignaturas
  def ver_instructores
    instructores.includes(:asignatura).map do |instructor|
      {
        id: instructor.id,
        nombre: instructor.nombre,
        correo: instructor.correo,
        asignatura: instructor.asignatura&.nombre
      }
    end
  end
end
