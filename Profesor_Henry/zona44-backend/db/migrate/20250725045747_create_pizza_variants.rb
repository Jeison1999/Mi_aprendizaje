class CreatePizzaVariants < ActiveRecord::Migration[8.0]
  def change
    create_table :pizza_variants do |t|
      t.references :pizza_base, null: false, foreign_key: true
      t.integer :size
      t.integer :price

      t.timestamps
    end
  end
end
