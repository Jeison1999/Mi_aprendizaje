class CreateUsuarios < ActiveRecord::Migration[7.0]
  def change
    create_table :usuarios do |t|
      t.string :nombre
      t.string :email, null: false
      t.string :password_digest, null: false
      t.integer :rol, default: 0  # 0 = cliente, 1 = admin

      t.timestamps
    end

    add_index :usuarios, :email, unique: true
  end
end
