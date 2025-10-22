class RenameAsignacionFichaInstructorsToAsignacionFichas < ActiveRecord::Migration[8.0]
  def change
    rename_table :asignacion_ficha_instructors, :asignacion_fichas
  end
end
