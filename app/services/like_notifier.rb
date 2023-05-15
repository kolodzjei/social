# frozen_string_literal: true

class LikeNotifier
  include ApplicationHelper

  def initialize(user, likeable)
    @user = user
    @likeable = likeable
  end

  def notify
    Notification.find_or_create_by(
      content: content,
      user: likeable.user,
      target: likeable,
      actor: user,
    )
  end

  private

  attr_reader :likeable, :user

  def content
    "liked your #{likeable.class.name.downcase}."
  end
end
