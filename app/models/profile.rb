# == Schema Information
#
# Table name: profiles
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_profiles_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
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
      errors.add(:avatar, 'は1つのファイル5MB以内にしてください')
    end
  end
end
