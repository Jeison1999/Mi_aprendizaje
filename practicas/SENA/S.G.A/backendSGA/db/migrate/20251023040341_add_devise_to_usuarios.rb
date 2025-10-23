class AddDeviseToUsuarios < ActiveRecord::Migration[8.0]
  def change
    # Agregar campos de Devise
    add_column :usuarios, :encrypted_password, :string, null: false, default: ""
    add_column :usuarios, :reset_password_token, :string
    add_column :usuarios, :reset_password_sent_at, :datetime
    add_column :usuarios, :remember_created_at, :datetime
    add_column :usuarios, :sign_in_count, :integer, default: 0, null: false
    add_column :usuarios, :current_sign_in_at, :datetime
    add_column :usuarios, :last_sign_in_at, :datetime
    add_column :usuarios, :current_sign_in_ip, :string
    add_column :usuarios, :last_sign_in_ip, :string
    add_column :usuarios, :confirmation_token, :string
    add_column :usuarios, :confirmed_at, :datetime
    add_column :usuarios, :confirmation_sent_at, :datetime
    add_column :usuarios, :unconfirmed_email, :string

    # Agregar índices
    add_index :usuarios, :reset_password_token, unique: true
    add_index :usuarios, :confirmation_token, unique: true
    add_index :usuarios, :unconfirmed_email

    # Remover el campo password_digest ya que usaremos encrypted_password
    remove_column :usuarios, :password_digest
  end
end
