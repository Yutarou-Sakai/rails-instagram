FactoryBot.define do
    factory :user do
        email { Faker::Internet.email }
        username { Faker::Lorem.characters(number: 5) }
        password { '123456' }
    end
end 