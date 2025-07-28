class AddCheeseBorderPriceToPizzaBases < ActiveRecord::Migration[8.0]
  def change
    add_column :pizza_bases, :cheese_border_price, :integer
  end
end
