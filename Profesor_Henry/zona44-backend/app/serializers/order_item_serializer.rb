class OrderItemSerializer < ActiveModel::Serializer
   attributes :id, :quantity, :subtotal

  belongs_to :product
end
