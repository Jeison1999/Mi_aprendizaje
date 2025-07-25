class PizzaVariant < ApplicationRecord
  belongs_to :pizza_base
  enum size: { personal: 0, small: 1, medium: 2, large: 3 }
end
