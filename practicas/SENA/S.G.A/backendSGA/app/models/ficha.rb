class Ficha < ApplicationRecord
  self.table_name = 'fichas'
  
  # Relaciones
  has_many :aprendizs, dependent: :destroy
  has_many :asignacion_ficha_instructors, foreign_key: 'fichaid'
  has_many :asignaturas, through: :asignacion_ficha_instructors
  has_many :instructores, through: :asignacion_ficha_instructors, source: :instructor
  
  # Validaciones
  validates :codigo, presence: true, uniqueness: true
  validates :nombre, presence: true
  
  # Método para agregar aprendiz
  def agregar_aprendiz(aprendiz_params)
    aprendizs.create(aprendiz_params)
  end
end
