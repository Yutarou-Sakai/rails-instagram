class Profile < ApplicationRecord
  belongs_to :user
  has_one_attached :avatar #active_strageを用いた仮のカラム

  validate :avatar_type, :avatar_size


  private

  def avatar_type
    if !avatar.blob.content_type.in?(%('image/jpeg image/png'))
      avatar.purge
      errors.add(:avatar, 'はjpegまたはpng形式でアップロードしてください')
    end
  end

  def avatar_size
    if avatar.blob.byte_size > 5.megabytes
      avatar.purge
      errors.add(:avatar, "は1つのファイル5MB以内にしてください")
    end
  end
end
