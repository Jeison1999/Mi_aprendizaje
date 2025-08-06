class DetalleAdicional < ApplicationRecord
  belongs_to :detalle_pedido
  belongs_to :adicional
end
