class PizzaSize < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :slices, presence: true, numericality: { greater_than: 0 }
  validates :diameter, presence: true, numericality: { greater_than: 0 }
  validates :base_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  
  has_many :pizza_variants, dependent: :destroy
end 