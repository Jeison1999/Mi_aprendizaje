class PizzaCombination < ApplicationRecord
  belongs_to :pizza_base1, class_name: 'PizzaBase'
  belongs_to :pizza_base2, class_name: 'PizzaBase'
  enum size: { personal: 0, small: 1, medium: 2, large: 3 }
end
