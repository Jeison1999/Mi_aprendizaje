class Producto < ApplicationRecord
  belongs_to :grupo
  has_one_attached :imagen
  has_many :precios_por_tamano
  has_many :producto_adicionales
  has_many :adicionales, through: :producto_adicionales

  validates :nombre, :precio, presence: true
end
