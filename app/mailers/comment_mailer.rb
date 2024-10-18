class CommentMailer < ApplicationMailer
  default from: 'notifications@example.com'

  def comment_notification(post, comment)
    @post = post
    @comment = comment
    @author = post.author

    mail(to: @author.email, subject: 'New Comment on Your Post')
  end
end
