class GroupSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :name, :image_url

  def image_url
    if object.image.attached?
      rails_blob_url(object.image, only_path: true)
    else
      nil
    end
  end
end
