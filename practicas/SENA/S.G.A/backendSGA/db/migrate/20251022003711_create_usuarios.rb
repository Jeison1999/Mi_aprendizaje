class CreateUsuarios < ActiveRecord::Migration[8.0]
  def change
    create_table :usuarios do |t|
      t.string :nombre, null: false
      t.string :correo, null: false
      t.string :password_digest, null: false
      t.string :rol, null: false

      t.timestamps
    end
    
    add_index :usuarios, :correo, unique: true
    add_index :usuarios, :rol
  end
end
