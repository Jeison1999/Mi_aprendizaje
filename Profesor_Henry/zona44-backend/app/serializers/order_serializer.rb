class OrderSerializer < ActiveModel::Serializer
  attributes :id, :total, :order_type, :status, :delivery_address, :phone

  has_many :order_items
  belongs_to :user
end
