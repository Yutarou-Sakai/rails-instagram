require 'rails_helper'

RSpec.describe Post, type: :model do
  context '画像と本文が入力されている場合' do
    before do
      user = User.create!({
        email: 'test@test.com',
        username: 'test',
        password: '123456'
      })
      @post = user.posts.build({
        content: Faker::Lorem.characters(number: 10),
      })
      @post.content_images.attach(io: File.open('app/assets/images/test1.jpg'), filename: 'test1.jpg')
      @post.content_images.attach(io: File.open('app/assets/images/test1.jpg'), filename: 'test1.jpg')
    end

    it '投稿を保存できる' do
      expect(@post).to be_valid
    end
  end

  context '画像が5枚以上の場合' do
    before do
      user = User.create!({
        email: 'test@test.com',
        username: 'test',
        password: '123456'
      })
      @post = user.posts.build({
        content: Faker::Lorem.characters(number: 10),
      })
      @post.content_images.attach(io: File.open('app/assets/images/test1.jpg'), filename: 'test1.jpg')
      @post.content_images.attach(io: File.open('app/assets/images/test1.jpg'), filename: 'test1.jpg')
      @post.content_images.attach(io: File.open('app/assets/images/test1.jpg'), filename: 'test1.jpg')
      @post.content_images.attach(io: File.open('app/assets/images/test1.jpg'), filename: 'test1.jpg')
      @post.content_images.attach(io: File.open('app/assets/images/test1.jpg'), filename: 'test1.jpg')
      @post.save
    end

    it '投稿を保存できない' do
      expect(@post.errors.messages[:content_images][0]).to eq('は4枚以内にしてください')
    end
  end
end
