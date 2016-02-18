class AddRentReturnedToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :rent_returned, :boolean, default: false
  end
end
