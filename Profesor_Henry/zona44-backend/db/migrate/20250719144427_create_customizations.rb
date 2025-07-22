class CreateCustomizations < ActiveRecord::Migration[8.0]
  def change
    create_table :customizations do |t|
      t.string :name
      t.integer :price
      t.references :product, null: false, foreign_key: true

      t.timestamps
    end
  end
end
