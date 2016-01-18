class Client < ActiveRecord::Base
  has_many :orders, dependent: :destroy

  validates :name, presence: true, length: {maximum: 100}
  validates :phone, presence: true, length: {maximum: 10},
                    uniqueness: true

  before_save {self.name = name.downcase}
end
