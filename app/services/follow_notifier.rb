# frozen_string_literal: true

class FollowNotifier
  def initialize(following, followed)
    @actor = following
    @user = followed
  end

  def notify
    return if actor == user

    Notification.find_or_create_by(
      content: content,
      user: user,
      target: actor,
      actor: actor,
    )
  end

  private

  attr_reader :user, :actor

  def content
    "just followed you."
  end
end
