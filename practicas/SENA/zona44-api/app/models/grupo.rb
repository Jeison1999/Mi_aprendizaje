class Grupo < ApplicationRecord
  has_one_attached :imagen
  has_many :productos, dependent: :destroy
  validates :nombre, presence: true
end
