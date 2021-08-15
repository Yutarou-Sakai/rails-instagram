FactoryBot.define do
    factory :profile do
        after(:build) do |profile|
            profile.avatar.attach(io: File.open('app/assets/images/avatar.png'), filename: 'avatar.png')
        end
    end
end