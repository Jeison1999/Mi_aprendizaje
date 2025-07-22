class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""
      t.integer :role,              default: 0    # cliente por defecto

      t.timestamps
    end

    add_index :users, :email, unique: true
  end
end
