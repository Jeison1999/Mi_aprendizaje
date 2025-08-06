class PrecioPorTamano < ApplicationRecord
  belongs_to :producto
  belongs_to :tamano_pizza

  validates :precio, presence: true
end
