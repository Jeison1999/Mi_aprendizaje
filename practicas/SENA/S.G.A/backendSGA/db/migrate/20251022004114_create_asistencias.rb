class CreateAsistencias < ActiveRecord::Migration[8.0]
  def change
    create_table :asistencias do |t|
      t.date :fecha, null: false
      t.string :estado, null: false
      t.integer :aprendizid, null: false
      t.integer :asignacionid, null: false

      t.timestamps
    end
    
    add_foreign_key :asistencias, :aprendizs, column: :aprendizid
    add_foreign_key :asistencias, :asignacion_ficha_instructors, column: :asignacionid
    
    add_index :asistencias, [:aprendizid, :asignacionid, :fecha], 
              unique: true, name: 'index_asistencias_unique'
  end
end
