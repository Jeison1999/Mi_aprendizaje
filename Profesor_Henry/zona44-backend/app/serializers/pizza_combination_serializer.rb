class PizzaCombinationSerializer < ActiveModel::Serializer
  attributes :id, :size, :price

  belongs_to :pizza_base1, serializer: PizzaBaseSerializer
  belongs_to :pizza_base2, serializer: PizzaBaseSerializer
end