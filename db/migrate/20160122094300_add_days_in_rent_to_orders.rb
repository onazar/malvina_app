class AddDaysInRentToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :days_in_rent, :integer
  end
end
