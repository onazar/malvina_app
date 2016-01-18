class Part < ActiveRecord::Base
  has_and_belongs_to_many :costumes

  belongs_to :part_type

  validates :part_type_id, presence: true

  validates :name, presence: true, length: {maximum: 100},
                   uniqueness: {case_sensitive: false}
  validates :description, length: {maximum: 255}

  before_save {self.name = name.downcase}
end
