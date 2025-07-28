class Ingredient < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :is_available, inclusion: { in: [true, false] }
  
  # Precios por tamaño almacenados como JSON
  serialize :prices_by_size, Hash
  
  has_many :pizza_ingredients, dependent: :destroy
  has_many :pizza_bases, through: :pizza_ingredients
end 