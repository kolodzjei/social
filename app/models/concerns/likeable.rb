# frozen_string_literal: true

module Likeable
  extend ActiveSupport::Concern

  included do
    has_many :likes, as: :likeable, dependent: :destroy
    has_many :likers, through: :likes, source: :user
    has_many :notifications, as: :target, dependent: :destroy
  end

  def like_count
    likes.count
  end

  def like(user)
    likes.create(user: user) unless liked_by?(user)
  end

  def unlike(user)
    likes.find_by(user: user).destroy if liked_by?(user)
  end

  def liked_by?(user)
    likers.include?(user)
  end
end
