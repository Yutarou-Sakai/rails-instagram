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
require 'rails_helper'

RSpec.describe Post, type: :model do
  let!(:user) { create(:user) }

  context '画像と本文が入力されている場合' do
    let!(:post) { build(:post, user: user) }

    it '投稿を保存できる' do
      expect(post).to be_valid
      # puts(post.content_images)
    end
  end

  context '画像が5枚以上の場合' do
    let!(:post) { build(:post, user: user) }

    before do
      5.times do
        post.content_images.attach(io: File.open('app/assets/images/test1.jpg'), filename: 'test1.jpg')
      end
      post.save
    end

    it '投稿を保存できない' do
      expect(post.errors.messages[:content_images][0]).to eq('は4枚以内にしてください')
    end
  end
end
