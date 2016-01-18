class CreateCostumesParts < ActiveRecord::Migration
  def change
    create_table :costumes_parts, id: false do |t|
      t.integer :costume_id
      t.integer :part_id
    end
  end
end
