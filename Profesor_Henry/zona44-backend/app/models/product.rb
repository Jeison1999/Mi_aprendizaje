class Product < ApplicationRecord
  belongs_to :group
  has_many :customizations, dependent: :destroy
  has_many :order_items

  validates :name, :price, presence: true
end
