class ChangeCorreoToEmailInUsuarios < ActiveRecord::Migration[8.0]
  def change
    # Cambiar el nombre de la columna de correo a email
    rename_column :usuarios, :correo, :email
  end
end
