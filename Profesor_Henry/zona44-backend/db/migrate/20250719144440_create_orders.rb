class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :total
      t.integer :order_type
      t.integer :status
      t.string :delivery_address
      t.string :phone

      t.timestamps
    end
  end
end
