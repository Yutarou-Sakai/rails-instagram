FactoryBot.define do
    factory :user do
        email { Faker::Internet.email }
        username { Faker::Lorem.characters(number: 5) }
        password { '123456' }

        trait :with_profile do
            after :build do |user|
                build(:profile, user: user)
            end
        end
    end
end 