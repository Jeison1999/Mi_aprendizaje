class AddOrderTypeToCustomizations < ActiveRecord::Migration[8.0]
  def change
    add_column :customizations, :order_type, :integer
  end
end
