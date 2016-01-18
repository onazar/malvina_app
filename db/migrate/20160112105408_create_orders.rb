class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.date :date
      t.integer :order_type, default: 0
      t.string :name
      t.integer :client_id

      t.timestamps null: false
    end
  end
end
