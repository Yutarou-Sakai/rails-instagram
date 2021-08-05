class CommentsController < ApplicationController
    before_action :set_post, only: [:index, :create]
    before_action :set_comments, only: [:create]


    def index
        # @comment = @post.comments.build

        @user_name = @post.user.username

        # @profile = Profile.find(params[:post_id])
        # avatar_data = url_for(profile.avatar)

        # render json: @comments
        respond_to do |f|
            f.json { render json: {comments: @comments, userName: @user_name }}
        end
    end

    def create
        @comment = @post.comments.build(comment_params)
        @comment.user = current_user
        if @comment.save
            render json: @comment
            # redirect_to post_comments_path(@post), notice: 'コメントを追加しました'
            @comment.content = ''
        else
            flash.now[:error] = '追加できませんでした'
            render :index
        end
    end

    def destroy
        
    end

    private
    def comment_params
        params.require(:comment).permit(:content)
    end

    def set_post
        @post = Post.find(params[:post_id])
    end

    def set_comments
        @comments = Comment.where(post_id: @post.id)
    end
end
