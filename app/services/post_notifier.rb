# frozen_string_literal: true

class PostNotifier
  def initialize(actor, post)
    @actor = actor
    @post = post
  end

  def notify_followers
    actor.followers.each do |follower|
      Notification.find_or_create_by(
        content: content,
        user: follower,
        target: post,
        actor: actor,
      )
    end
  end

  private

  attr_reader :actor, :post
  
  def content
    "published a new post."
  end
end
