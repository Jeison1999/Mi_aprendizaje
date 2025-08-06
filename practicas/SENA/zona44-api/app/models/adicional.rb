class Adicional < ApplicationRecord
  has_many :producto_adicionales
  has_many :productos, through: :producto_adicionales

  validates :nombre, presence: true
end
