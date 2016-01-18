class OrderedPart < ActiveRecord::Base
  belongs_to: orders

  validates :ordered_part_id, presence: true
  validates :order_id, presence: true
end
