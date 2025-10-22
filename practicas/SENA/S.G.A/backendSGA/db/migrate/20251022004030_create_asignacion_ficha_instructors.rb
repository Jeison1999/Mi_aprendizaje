class CreateAsignacionFichaInstructors < ActiveRecord::Migration[8.0]
  def change
    create_table :asignacion_ficha_instructors do |t|
      t.integer :instructorid, null: false
      t.integer :asignaturaid, null: false
      t.integer :fichaid, null: false

      t.timestamps
    end
    
    add_foreign_key :asignacion_ficha_instructors, :usuarios, column: :instructorid
    add_foreign_key :asignacion_ficha_instructors, :asignaturas, column: :asignaturaid
    add_foreign_key :asignacion_ficha_instructors, :fichas, column: :fichaid
    
    add_index :asignacion_ficha_instructors, [:instructorid, :asignaturaid, :fichaid], 
              unique: true, name: 'index_asignacion_unique'
  end
end
