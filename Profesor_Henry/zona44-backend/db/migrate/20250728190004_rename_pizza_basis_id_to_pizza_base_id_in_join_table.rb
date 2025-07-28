class RenamePizzaBasisIdToPizzaBaseIdInJoinTable < ActiveRecord::Migration[6.0]
  def change
    rename_column :pizza_bases_toppings, :pizza_basis_id, :pizza_base_id
  end
end
