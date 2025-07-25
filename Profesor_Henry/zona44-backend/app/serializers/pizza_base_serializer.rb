class PizzaBaseSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :category, :image_url

  has_many :pizza_variants
  has_many :toppings

  def image_url
    object.image.attached? ? Rails.application.routes.url_helpers.rails_blob_url(object.image, host: ENV['HOST_URL'] || 'http://localhost:3000') : nil
  end
end
