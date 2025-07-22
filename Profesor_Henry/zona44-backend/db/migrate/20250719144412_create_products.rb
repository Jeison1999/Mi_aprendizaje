class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.integer :price
      t.string :image_url
      t.boolean :customizable
      t.references :group, null: false, foreign_key: true

      t.timestamps
    end
  end
end
