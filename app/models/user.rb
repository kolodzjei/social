# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
    :registerable,
    :recoverable,
    :rememberable,
    :validatable

  has_many :follower_relationships, foreign_key: :followed_id, class_name: "Relationship", dependent: :destroy
  has_many :followers, through: :follower_relationships, source: :follower

  has_many :followed_relationships, foreign_key: :follower_id, class_name: "Relationship", dependent: :destroy
  has_many :following, through: :followed_relationships, source: :followed

  def follow(user)
    following << user unless following.include?(user) || user == self
  end

  def unfollow(user)
    following.delete(user)
  end
end
