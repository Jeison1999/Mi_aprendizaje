class Topping < ApplicationRecord
  has_and_belongs_to_many :pizza_base
end
