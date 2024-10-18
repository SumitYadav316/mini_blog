class PostSerializer < ActiveModel::Serializer
  attributes :id, :title, :content, :image, :created_at, :updated_at
  def image
    if object.image.attached?
      Rails.application.routes.url_helpers.rails_blob_url(object.image, only_path: true)
    else
      nil
    end
  end
  has_many :comments
end