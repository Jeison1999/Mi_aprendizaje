class CreateTamanoPizzas < ActiveRecord::Migration[8.0]
  def change
    create_table :tamano_pizzas do |t|
      t.string :nombre, null: false
      t.integer :porciones, null: false

      t.timestamps
    end
  end
end
