class CreateDetallePedidos < ActiveRecord::Migration[8.0]
  def change
    create_table :detalle_pedidos do |t|
      t.references :pedido, null: false, foreign_key: true
      t.references :producto, null: false, foreign_key: true
      t.integer :cantidad, default: 1
      t.decimal :subtotal, precision: 10, scale: 2

      t.timestamps
    end
  end
end
