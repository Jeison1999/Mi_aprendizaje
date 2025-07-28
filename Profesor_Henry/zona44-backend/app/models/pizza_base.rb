class PizzaBase < ApplicationRecord
  has_many :pizza_variants, dependent: :destroy
  has_many :pizza_ingredients, dependent: :destroy
  has_many :ingredients, through: :pizza_ingredients
  has_one_attached :image
  
  # Mantener la relación existente con toppings
  has_and_belongs_to_many :toppings
  
  validates :name, presence: true
  validates :description, presence: true
  validates :category, presence: true, inclusion: { in: %w[tradicional especial combinada] }
  
  # Nuevos campos para precios por tamaño
  serialize :prices_by_size, Hash
  serialize :included_ingredients, Array
  serialize :cheese_border_prices, Hash
  
  accepts_nested_attributes_for :pizza_variants, allow_destroy: true
  accepts_nested_attributes_for :pizza_ingredients, allow_destroy: true
  
  enum :category, { tradicional: 0, especial: 1, combinada: 2 }
end
