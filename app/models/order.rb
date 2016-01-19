class Order < ActiveRecord::Base
  belongs_to :client, dependent: :destroy

  has_many :ordered_parts, dependent: :destroy

  enum order_type: [:costume, :part]

  validates :client_id, presence: true

  validates :date, presence: true

  validates :name, presence: true, length: {maximum: 100}

  before_save {self.name = name.downcase}

end
