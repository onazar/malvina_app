class CreateOrderedParts < ActiveRecord::Migration
  def change
    create_table :ordered_parts, id: false do |t|
      t.integer :ordered_part_id
      t.integer :order_id

      t.timestamps null: false
    end
  end
end
