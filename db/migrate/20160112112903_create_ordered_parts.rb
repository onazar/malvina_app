class CreateOrderedParts < ActiveRecord::Migration
  def change
    create_table :ordered_parts do |t|
      t.integer :ordered_part_id

      t.timestamps null: false
    end
  end
end
