class RemoveAsignaturaFromAsignacionFichaInstructor < ActiveRecord::Migration[8.0]
  def change
    # Primero remover el foreign key si existe
    if foreign_key_exists?(:asignacion_ficha_instructors, column: :asignaturaid)
      remove_foreign_key :asignacion_ficha_instructors, column: :asignaturaid
    end
    
    # Remover el índice compuesto existente
    if index_exists?(:asignacion_ficha_instructors, [:instructorid, :asignaturaid, :fichaid], name: 'index_asignacion_unique')
      remove_index :asignacion_ficha_instructors, name: 'index_asignacion_unique'
    end
    
    # Remover la columna
    remove_column :asignacion_ficha_instructors, :asignaturaid, :integer
    
    # Agregar nuevo índice único solo para instructor-ficha
    add_index :asignacion_ficha_instructors, [:instructorid, :fichaid], 
              unique: true, name: 'index_instructor_ficha_unique'
  end
end
