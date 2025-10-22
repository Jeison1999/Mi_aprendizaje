class CreateAsignaturas < ActiveRecord::Migration[8.0]
  def change
    create_table :asignaturas do |t|
      t.string :nombre, null: false

      t.timestamps
    end
    
    add_index :asignaturas, :nombre, unique: true
  end
end
