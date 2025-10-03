class CreateProductos < ActiveRecord::Migration[8.0]
  def change
    create_table :productos do |t|
      t.string :nombre
      t.text :descripcion
      t.decimal :precio
      t.references :grupo, null: false, foreign_key: true

      t.timestamps
    end
  end
end
