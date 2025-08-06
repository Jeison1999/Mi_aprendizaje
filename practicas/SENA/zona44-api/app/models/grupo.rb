class Grupo < ApplicationRecord
  has_many :productos, dependent: :destroy
  validates :nombre, presence: true
end
