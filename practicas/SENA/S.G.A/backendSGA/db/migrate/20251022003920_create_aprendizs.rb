class CreateAprendizs < ActiveRecord::Migration[8.0]
  def change
    create_table :aprendizs do |t|
      t.string :nombre, null: false
      t.string :tipodocumento, null: false
      t.integer :ndocumento, null: false
      t.string :correo, null: false
      t.references :ficha, null: false, foreign_key: true

      t.timestamps
    end
    
    add_index :aprendizs, [:tipodocumento, :ndocumento], unique: true
  end
end
