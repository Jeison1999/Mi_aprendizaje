class TamanoPizza < ApplicationRecord
  has_many :precios_por_tamano
  validates :nombre, presence: true
  validates :porciones, numericality: { only_integer: true }
end
