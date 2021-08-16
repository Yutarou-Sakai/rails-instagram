require 'rails_helper'

RSpec.describe 'Post', type: :system do
    let!(:user) { create(:user) }
    let!(:posts) { create_list(:post, 3, user: user) }

    it '投稿一覧が表示される' do
        visit root_path

        posts.each do |post|
            expect(page).to have_css('.content_body', text: post.content)
        end
    end

    it '投稿の詳細を表示できる' do
        visit root_path

        post = posts.last
        first('.comment_link').click
        expect(page).to have_css('.content_body', text: post.content)
    end
end
