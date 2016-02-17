class AddReservationFeeToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :reservation_fee, :integer
  end
end
