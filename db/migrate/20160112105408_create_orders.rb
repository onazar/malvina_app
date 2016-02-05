class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.date :date
      t.string :name

      t.timestamps null: false
    end
  end
end
