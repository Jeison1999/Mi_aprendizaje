class CreateProductos < ActiveRecord::Migration[8.0]
  def change
    create_table :productos do |t|
      t.string :nombre, null: false
      t.text :descripcion
      t.string :imagen
      t.references :grupo, null: false, foreign_key: true

      t.timestamps
    end
  end
end
