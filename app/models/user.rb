# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  username               :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :authentication_keys => [:login]

  has_one :profile, dependent: :destroy #ユーザーは１つのプロフィールを持つ
  has_many :posts, dependent: :destroy #ユーザーは複数の投稿を持つ
  has_many :likes, dependent: :destroy #ユーザーは複数のいいねを持つ
  has_many :comments, dependent: :destroy #ユーザーは複数のコメントを持つ

  # 自分がフォローしているuserを探す
  has_many :following_relationships, foreign_key: 'follower_id', class_name: 'Relationship', dependent: :destroy
  has_many :followings, through: :following_relationships, source: :following

  # 自分のフォロワーとなっているuserを探す
  has_many :follower_relationships, foreign_key: 'following_id', class_name: 'Relationship', dependent: :destroy
  has_many :followers, through: :follower_relationships, source: :follower

  attr_accessor :login

  validates :username,
    uniqueness: { case_sensitive: :false }, #一意のusernameで大小文字を区別しない
    length: { minimum: 3, maximum: 20 } #3文字以上20文字以内


  
  # カウント
  def post_count(user)
    posts = user.posts
    posts.size
  end

  def follower_count(user)
    followers = user.followers
    followers.size
  end

  def following_count(user)
    followings = user.followings
    followings.size
  end

  # いいね機能
  def has_liked?(post)
    likes.exists?(post_id: post.id)
  end

  # フォロー機能
  def follow!(user)
    user_id = get_user_id(user)
    following_relationships.create!(following_id: user_id)
  end

  def unfollow!(user)
    user_id = get_user_id(user)
    relation = following_relationships.find_by!(following_id: user_id)
    relation.destroy!
  end
  
  def has_followed?(user)
    following_relationships.exists?(following_id: user.id)
  end

  # メール機能
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["username = :value OR lower(email) = lower(:value)", { :value => login }]).first
    else
      where(conditions).first
    end
  end

  # プロフィール関連
  def prepare_profile #プロフィールの情報があればそれを、なければ空を渡す
    profile || build_profile
  end

  # アバター関連
  def avatar_image #アバターがあればそれを、なければno-img-avatar.jpgを返す
    if profile&.avatar&.attached?
      profile.avatar
    else
      'no-img-avatar.png'
    end
  end


  private
  def get_user_id(user)
    if user.is_a?(User)
      user.id
    else
      user
    end
  end
end
