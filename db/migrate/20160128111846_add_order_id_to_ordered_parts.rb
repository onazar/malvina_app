class AddOrderIdToOrderedParts < ActiveRecord::Migration
  def change
    add_column :ordered_parts, :order_id, :integer
  end
end
