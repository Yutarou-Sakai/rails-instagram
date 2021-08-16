# == Schema Information
#
# Table name: posts
#
#  id         :bigint           not null, primary key
#  content    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_posts_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Post < ApplicationRecord
  belongs_to :user

  has_many :likes, dependent: :destroy #投稿は複数のいいねを持つ
  has_many :comments, dependent: :destroy #投稿は複数のコメントを持つ

  has_many_attached :content_images #active strageで画像を複数枚保存

  validates :content, presence: true
  validates :content, length: { minimum: 2, maximum: 100 }

  validates :content_images, presence: true
  validate :content_image_type, :content_image_size, :content_image_length


  private

  def content_image_type
    content_images.each do |content_image|
      if !content_image.blob.content_type.in?(%('image/jpeg image/png'))
        content_image.purge
        errors.add(:content_images, 'はjpegまたはpng形式でアップロードしてください')
      end
    end
  end

  def content_image_size
    content_images.each do |content_image|
      if content_image.blob.byte_size > 5.megabytes
        content_image.purge
        errors.add(:content_images, "は1つのファイル5MB以内にしてください")
      end
    end
  end

  def content_image_length
    if content_images.length > 4
      content_images = nil
      errors.add(:content_images, "は4枚以内にしてください")
    end
  end
end
