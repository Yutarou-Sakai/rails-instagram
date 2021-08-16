require 'rails_helper'

RSpec.describe 'Profile', type: :system do
    let!(:user) { create(:user, :with_profile) }

    context 'ログインしている場合' do
        before do
            sign_in user
        end

        it '自分のプロフィールを確認できる' do
            visit profile_path
            expect(page).to have_css('.profile_name', text: user.username)
        end
    end
end
