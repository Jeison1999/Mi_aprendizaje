class CreatePizzaCombinations < ActiveRecord::Migration[8.0]
  def change
    create_table :pizza_combinations do |t|
      t.integer :pizza_base1_id
      t.integer :pizza_base2_id
      t.integer :size
      t.integer :price

      t.timestamps
    end
  end
end
