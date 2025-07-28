class CreatePizzaBases < ActiveRecord::Migration[8.0]
  def change
    create_table :pizza_bases do |t|
      t.string :name
      t.text :description
      t.integer :category, default: 0, null: false

      t.timestamps
    end
  end
end
