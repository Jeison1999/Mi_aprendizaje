class ChangeCategoryDefaultInPizzaBases < ActiveRecord::Migration[8.0]
  def up
    change_column :pizza_bases, :category, :integer, default: 0, null: false
  end

  def down
    change_column :pizza_bases, :category, :integer, default: nil, null: true
  end
end
