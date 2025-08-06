class Producto < ApplicationRecord
  belongs_to :grupo
  has_many :precios_por_tamano
  has_many :producto_adicionales
  has_many :adicionales, through: :producto_adicionales

  validates :nombre, presence: true
end
