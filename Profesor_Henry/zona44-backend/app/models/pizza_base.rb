class PizzaBase < ApplicationRecord
  has_many :pizza_variants, dependent: :destroy
  has_one_attached :image
  enum category: { tradicional: 0, especial: 1, combinada: 2 }
  has_and_belongs_to_many :toppings
end
