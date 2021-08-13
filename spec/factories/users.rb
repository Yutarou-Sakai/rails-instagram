FactoryBot.define do
    factory :user do
        email { Faker::Internet.email }
        username { Faker::Name.unique.name }
        password { '123456' }
    end
end 