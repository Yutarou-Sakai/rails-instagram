class PostsController < ApplicationController
    before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]

    def index
        @posts = Post.all
    end 

    def new
        @post = current_user.posts.build
    end

    def create
        @post = current_user.posts.build(post_params)
        if @post.save
            redirect_to root_path, notice: '保存ができました'
        else
            flash.now[:error] = '保存できませんでした'
            render :new
        end
    end


    private
    def post_params #フォームの入力内容
        params.require(:post).permit(:content, content_images: [])
    end

end
