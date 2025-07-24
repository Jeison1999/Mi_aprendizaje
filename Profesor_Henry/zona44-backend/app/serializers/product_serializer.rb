class ProductSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :name, :description, :price, :group_id, :image_url

  def image_url
    if object.image.attached?
      url_for(object.image)
    else
      nil
    end
  end
end
