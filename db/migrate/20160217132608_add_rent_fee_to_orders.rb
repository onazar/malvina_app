class AddRentFeeToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :rent_fee, :integer
  end
end
