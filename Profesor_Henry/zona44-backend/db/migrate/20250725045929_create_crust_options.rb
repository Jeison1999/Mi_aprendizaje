class CreateCrustOptions < ActiveRecord::Migration[8.0]
  def change
    create_table :crust_options do |t|
      t.integer :size
      t.integer :price

      t.timestamps
    end
  end
end
