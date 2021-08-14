FactoryBot.define do
    factory :post do
        content { Faker::Lorem.characters(number: 50) }

        after(:build) do |post|
            post.content_images.attach(io: File.open('app/assets/images/test1.jpg'), filename: 'test1.jpg')
        end
    end
end 