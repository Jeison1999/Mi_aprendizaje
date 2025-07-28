class PizzaIngredient < ApplicationRecord
  belongs_to :pizza_base
  belongs_to :ingredient
  
  validates :pizza_base_id, uniqueness: { scope: :ingredient_id }
end 