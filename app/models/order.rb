class Order < ActiveRecord::Base
  has_many :ordered_parts, dependent: :destroy

  validates :date, presence: true

  validates :return_date, presence: true

  validates :days_in_rent, presence: true

  validates :name, presence: true, length: {maximum: 100}

  validates :tbd, length: {maximum: 255}

  validates :client_name, presence: true, length: {maximum: 100}
  validates :client_phone, presence: true, length: {is: 10}

  before_save {self.client_name = client_name.downcase}

  before_save {self.name = name.downcase}

end
