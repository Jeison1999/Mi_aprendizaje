class CreateFichas < ActiveRecord::Migration[8.0]
  def change
    create_table :fichas do |t|
      t.string :codigo, null: false
      t.string :nombre, null: false

      t.timestamps
    end
    
    add_index :fichas, :codigo, unique: true
  end
end
