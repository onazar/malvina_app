class Costume < ActiveRecord::Base
  has_and_belongs_to_many :parts

  validates :name, presence: true, length: {maximum: 100},
                   uniqueness: {case_sensitive: false}
  validates :description, length: {maximum: 255}

  before_save {self.name = name.downcase}
end
