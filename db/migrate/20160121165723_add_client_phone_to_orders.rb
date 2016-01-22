class AddClientPhoneToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :client_phone, :string
  end
end
