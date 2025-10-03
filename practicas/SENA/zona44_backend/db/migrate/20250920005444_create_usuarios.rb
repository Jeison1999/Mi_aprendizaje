class CreateUsuarios < ActiveRecord::Migration[8.0]
  def change
    create_table :usuarios do |t|
      t.string :email
      t.string :password_digest
      t.string :role

      t.timestamps
    end
  end
end
