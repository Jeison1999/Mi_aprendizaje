class CreatePrecioPorTamanos < ActiveRecord::Migration[7.0]
  def change
    create_table :precio_por_tamanos do |t|
      t.references :producto, null: false, foreign_key: true
      t.references :tamano_pizza, null: false, foreign_key: true
      t.decimal :precio, precision: 10, scale: 2

      t.timestamps
    end

    add_index :precio_por_tamanos, [:producto_id, :tamano_pizza_id], unique: true
  end
end
