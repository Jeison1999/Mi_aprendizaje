class Customization < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy

  enum status: { pendiente: 0, en_preparacion: 1, entregado: 2, cancelado: 3 }
  enum order_type: { recoge: 0, domicilio: 1 }
end
