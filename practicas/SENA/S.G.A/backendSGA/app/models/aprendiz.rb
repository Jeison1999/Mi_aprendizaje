class Aprendiz < ApplicationRecord
  self.table_name = 'aprendizs'
  
  # Relaciones
  belongs_to :ficha
  has_many :asistencias, foreign_key: 'aprendizid', dependent: :destroy
  
  # Validaciones
  validates :nombre, presence: true
  validates :tipodocumento, presence: true, inclusion: { in: %w[CC TI CE PPT] }
  validates :ndocumento, presence: true, uniqueness: { scope: :tipodocumento }
  validates :correo, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  
  # Scopes
  scope :por_ficha, ->(ficha_id) { where(ficha_id: ficha_id) }
end
