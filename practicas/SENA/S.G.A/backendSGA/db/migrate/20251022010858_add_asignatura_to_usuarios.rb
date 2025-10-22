class AddAsignaturaToUsuarios < ActiveRecord::Migration[8.0]
  def change
    add_reference :usuarios, :asignatura, null: true, foreign_key: true
  end
end
