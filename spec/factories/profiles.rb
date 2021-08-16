# == Schema Information
#
# Table name: profiles
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_profiles_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
    factory :profile do
        after(:build) do |profile|
            profile.avatar.attach(io: File.open('app/assets/images/avatar.png'), filename: 'avatar.png')
        end
    end
end
