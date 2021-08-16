require 'rails_helper'

RSpec.describe 'Posts', type: :request do
  let!(:user) { create(:user) }
  let!(:posts) { create_list(:post, 5, user: user) }

  describe 'GET /posts' do
    it '200ステータスが返ってくる' do
      get posts_path
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST /posts' do
    context 'ログインしている場合' do
      before do
        sign_in user
      end

      it '投稿が保存される' do
        post_params = attributes_for(:post)
        image = ActiveStorage::Blob.create_after_upload!(
          io: File.open('app/assets/images/test1.jpg'), filename: 'test1.jpg'
        ).signed_id
        post_params[:content_images] = [image]
        post posts_path({post: post_params})

        expect(response).to have_http_status(302)
        expect(Post.last.content).to eq(post_params[:content])
      end
    end

    context 'ログインしていない場合' do
      it 'ログイン画面にリダイレクトする' do
        post_params = attributes_for(:post)
        post posts_path({post: post_params})

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
