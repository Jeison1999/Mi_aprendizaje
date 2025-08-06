class DetallePedido < ApplicationRecord
  belongs_to :pedido
  belongs_to :producto

  has_many :detalle_adicionals, dependent: :destroy
  has_many :adicionales, through: :detalle_adicionals

  validates :cantidad, numericality: { only_integer: true }
end
