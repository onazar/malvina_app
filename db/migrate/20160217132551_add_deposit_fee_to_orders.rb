class AddDepositFeeToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :deposit_fee, :integer
  end
end
