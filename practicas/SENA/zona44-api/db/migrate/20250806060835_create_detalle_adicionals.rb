class CreateDetalleAdicionals < ActiveRecord::Migration[8.0]
  def change
    create_table :detalle_adicionals do |t|
      t.references :detalle_pedido, null: false, foreign_key: true
      t.references :adicional, null: false, foreign_key: true

      t.timestamps
    end
  end
end
