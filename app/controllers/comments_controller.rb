class CommentsController < ApplicationController
    def index
        @comments = Comment.all

        post = Post.find(params[:post_id])
        @comment = post.comments.build
    end

    def create
        post = Post.find(params[:post_id])
        @comment = post.comments.build(comment_params)
        @comment.user = current_user
        if @comment.save
            redirect_to post_comments_path(post), notice: 'コメントを追加しました'
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
end
