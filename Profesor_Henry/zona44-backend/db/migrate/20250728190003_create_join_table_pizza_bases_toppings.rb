class CreateJoinTablePizzaBasesToppings < ActiveRecord::Migration[8.0]
  def change
    create_join_table :pizza_bases, :toppings do |t|
      # t.index [:pizza_base_id, :topping_id]
      # t.index [:topping_id, :pizza_base_id]
    end
  end
end
