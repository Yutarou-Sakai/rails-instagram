class TimelinesController < ApplicationController
    before_action :authenticate_user!

    def show
        user_ids = current_user.followings.pluck(:id)

        from  = Time.current.at_beginning_of_day
        to    = (from + 1.day)

        @popular_posts = Post.joins(:likes).group("posts.id").order("count(posts.id) desc").limit(5)

        @posts = @popular_posts.where(created_at: from...to)

    end
end
