class CommentNotificationJob < ApplicationJob
  queue_as :default

  def perform(post, comment)
    CommentMailer.comment_notification(post, comment).deliver_now
  end
end
