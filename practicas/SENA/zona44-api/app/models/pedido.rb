class Pedido < ApplicationRecord
  belongs_to :usuario
  has_many :detalles_pedido, dependent: :destroy

  enum estado: { pendiente: 0, en_proceso: 1, finalizado: 2 }
  enum metodo_entrega: { domicilio: 0, recoger: 1 }

  validates :total, numericality: true
end
