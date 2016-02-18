class AddInRentToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :in_rent, :boolean, default: false
  end
end
