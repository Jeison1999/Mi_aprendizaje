class CreatePedidos < ActiveRecord::Migration[8.0]
  def change
    create_table :pedidos do |t|
      t.references :usuario, null: false, foreign_key: true
      t.decimal :total, precision: 10, scale: 2, default: 0.0
      t.integer :estado, default: 0   # pendiente
      t.integer :metodo_entrega  # 0 = domicilio, 1 = recoger
      t.boolean :pagado, default: false

      t.timestamps
    end
  end
end
