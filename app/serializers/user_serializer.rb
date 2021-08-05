class UserSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :username, :avatar_image

  def avatar
    if object.avatar_image != 'no-img-avatar.png'
      rails_blob_path(object.avatar_image) 
    else
      "no-img-avatar.png"
    end
  end
end
