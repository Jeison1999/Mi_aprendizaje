class Usuario < ApplicationRecord
  self.table_name = 'usuarios'
  has_secure_password
  
  # Relaciones
  has_many :asignacion_ficha_instructors, foreign_key: 'instructorid'
  has_many :fichas, through: :asignacion_ficha_instructors
  has_many :asignaturas, through: :asignacion_ficha_instructors
  
  # Validaciones
  validates :nombre, presence: true
  validates :correo, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :rol, presence: true, inclusion: { in: %w[admin instructor] }
  
  # Scopes
  scope :admins, -> { where(rol: 'admin') }
  scope :instructores, -> { where(rol: 'instructor') }
  
  # Métodos
  def admin?
    rol == 'admin'
  end
  
  def instructor?
    rol == 'instructor'
  end
end
