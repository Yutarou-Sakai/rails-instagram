class CommentsController < ApplicationController
    before_action :set_post, only: [:index, :create]
    before_action :set_comments, only: [:index, :create]


    def index
        render json: @comments, include: { user: [:profile] }
    end

    def create
        @comment = @post.comments.build(comment_params)
        if @comment.save
            send_email(@comment, @post)
        end

        render json: @comment, include: { user: [:profile] }
    end

    def destroy
        
    end



    private
    def comment_params
        params.require(:comment).permit(:content).merge(user_id: current_user.id)
    end

    def set_post
        @post = Post.find(params[:post_id])
    end

    def set_comments
        @comments = Comment.where(post_id: @post.id)
    end

    def send_email(comment, post)
        username = '@' + current_user.username
        content = comment.content
        if content.include?(username)
            MentionMailer.comment_mention(User.first, post).deliver_now
        end
    end
end
