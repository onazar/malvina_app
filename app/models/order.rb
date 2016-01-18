class Order < ActiveRecord::Base
  belongs_to :clients, dependent: :destroy

  has_many :ordered_parts, dependent: :destroy

  enum order_type: [:costume, :part]

  validates :client_id, presence: true

  validates :date, presence: true, 
                   format: /(0[1-9]|[12][0-9]|3[01])[- \/.](0[1-9]|1[012])[- \/.]20\d\d/
  validates :name, presence: true, length: {maximum: 100}

  before_save {self.name = name.downcase}

end
