class UpdateAsistenciasForeignKey < ActiveRecord::Migration[8.0]
  def change
    # Remover el foreign key viejo
    remove_foreign_key :asistencias, column: :asignacionid if foreign_key_exists?(:asistencias, column: :asignacionid)
    
    # Agregar el nuevo foreign key apuntando a asignacion_fichas
    add_foreign_key :asistencias, :asignacion_fichas, column: :asignacionid
  end
end
