# frozen_string_literal: true

class ReplyNotifier
  def initialize(actor, reply)
    @actor = actor
    @reply = reply
  end

  def notify
    return if user == actor

    Notification.find_or_create_by(
      content: content,
      user: user,
      target: reply,
      actor: actor,
    )
  end

  private

  attr_reader :actor, :reply

  def content
    "replied to your comment."
  end

  def user
    @user ||= (reply.has_parent? ? reply.parent_reply.user : reply.comment.user)
  end
end
