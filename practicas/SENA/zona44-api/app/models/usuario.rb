class Usuario < ApplicationRecord
  has_secure_password  # maneja validación y hash de contraseñas

  enum :rol, { cliente: 0, admin: 1 }

  validates :email, presence: true, uniqueness: true
end
