class MentionMailer < ApplicationMailer
    def comment_mention(user, post)
        @user = user
        @post = post
        mail to: user.email, subject: 'あなた宛にコメントがあります'
    end
end
