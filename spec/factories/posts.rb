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
FactoryBot.define do
    factory :post do
        content { Faker::Lorem.characters(number: 50) }

        after(:build) do |post|
            post.content_images.attach(io: File.open('app/assets/images/test1.jpg'), filename: 'test1.jpg')
        end
    end
end 
