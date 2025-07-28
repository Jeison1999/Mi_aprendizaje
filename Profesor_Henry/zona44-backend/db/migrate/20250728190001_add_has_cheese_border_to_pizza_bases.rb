class AddHasCheeseBorderToPizzaBases < ActiveRecord::Migration[8.0]
  def change
    add_column :pizza_bases, :has_cheese_border, :boolean
  end
end
