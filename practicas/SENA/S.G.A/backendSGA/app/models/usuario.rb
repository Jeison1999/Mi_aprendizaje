class Usuario < ApplicationRecord
  self.table_name = 'usuarios'
  has_secure_password
  
  # Relaciones
  belongs_to :asignatura, optional: true  # Solo para instructores
  has_many :asignacion_fichas, foreign_key: 'instructorid', dependent: :destroy
  has_many :fichas, through: :asignacion_fichas
  
  # Validaciones
  validates :nombre, presence: true
  validates :correo, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :rol, presence: true, inclusion: { in: %w[admin instructor] }
  validates :asignatura_id, presence: true, if: :instructor?
  
  # Scopes
  scope :admins, -> { where(rol: 'admin') }
  scope :instructores, -> { where(rol: 'instructor') }
  scope :por_asignatura, ->(asignatura_id) { where(asignatura_id: asignatura_id) }
  
  # Métodos
  def admin?
    rol == 'admin'
  end
  
  def instructor?
    rol == 'instructor'
  end
  
  # Método para que admin asigne fichas
  def asignar_ficha(ficha)
    return false unless instructor?
    asignacion_fichas.find_or_create_by(ficha: ficha)
  end
  
  # Ver fichas asignadas con detalles
  def ver_fichas
    return [] unless instructor?
    fichas.includes(:aprendizs)
  end
end
