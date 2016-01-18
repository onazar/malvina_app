class AddPartTypeIdToParts < ActiveRecord::Migration
  def change
    add_column :parts, :part_type_id, :integer
  end
end
