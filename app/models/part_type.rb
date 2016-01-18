class PartType < ActiveRecord::Base
  has_many :parts, dependent: :destroy

  validates :type_name, presence: true, length: {maximum: 100},
                        uniqueness: {case_sensitive: false}

  before_save {self.type_name = type_name.downcase}
end
