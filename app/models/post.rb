class Post < ApplicationRecord
  belongs_to :user
  has_many_attached :content_images #active strageで画像を複数枚保存
end
