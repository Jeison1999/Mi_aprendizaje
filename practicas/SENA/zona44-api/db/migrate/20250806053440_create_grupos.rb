class CreateGrupos < ActiveRecord::Migration[8.0]
  def change
    create_table :grupos do |t|
      t.string :nombre, null: false
      t.string :imagen

      t.timestamps
    end
  end
end
