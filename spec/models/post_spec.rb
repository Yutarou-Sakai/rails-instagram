require 'rails_helper'

RSpec.describe Post, type: :model do
  it '画像と本文が入力されている場合、投稿を保存できる' do
    user = User.create!({
      email: 'test@test.com',
      username: 'test',
      password: '123456'
    })

    post = user.posts.build({
      content: Faker::Lorem.characters(number: 10),
    })
    post.content_images.attach(io: File.open('app/assets/images/test1.jpg'), filename: 'test1.jpg')

    expect(post).to be_valid
  end
end
