class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy
  accepts_nested_attributes_for :order_items


  enum :order_type, { para_llevar: 0, en_el_lugar: 1 }
  enum :status, { pendiente: 0, en_preparacion: 1, entregado: 2, cancelado: 3 }

  validates :total, :order_type, :status, presence: true
end
