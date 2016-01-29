class AddTbdToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :tbd, :string
  end
end
