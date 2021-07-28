class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :authentication_keys => [:login]

  has_one :profile, dependent: :destroy #ユーザーは１つのプロフィールを持つ

  attr_accessor :login

  validates :username,
    uniqueness: { case_sensitive: :false }, #一意のusernameで大小文字を区別しない
    length: { minimum: 3, maximum: 20 } #3文字以上20文字以内


  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["username = :value OR lower(email) = lower(:value)", { :value => login }]).first
    else
      where(conditions).first
    end
  end

  def avatar_image #アバターがあればそれを、なければno-img-avatar.jpgを返す
    if profile&.avatar&.attached?
      profile.avatar
    else
      'no-img-avatar.jpg'
    end
  end
end
