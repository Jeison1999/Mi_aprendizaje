class ProductSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :price, :image_url, :customizable

  belongs_to :group
  has_many :customizations
end
