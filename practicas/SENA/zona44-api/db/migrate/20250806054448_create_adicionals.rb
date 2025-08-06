class CreateAdicionals < ActiveRecord::Migration[8.0]
  def change
    create_table :adicionals do |t|
      t.string :nombre, null: false
      t.decimal :precio, precision: 10, scale: 2
      t.string :imagen

      t.timestamps
    end
  end
end
