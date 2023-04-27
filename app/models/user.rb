# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable,
    :registerable,
    :recoverable,
    :rememberable,
    :validatable,
    :omniauthable,
    omniauth_providers: [:google]

  has_many :follower_relationships, foreign_key: :followed_id, class_name: "Relationship", dependent: :destroy
  has_many :followers, through: :follower_relationships, source: :follower

  has_many :followed_relationships, foreign_key: :follower_id, class_name: "Relationship", dependent: :destroy
  has_many :following, through: :followed_relationships, source: :followed

  has_many :posts, dependent: :destroy

  has_many :likes, dependent: :destroy

  has_many :comments, dependent: :destroy

  has_many :replies, dependent: :destroy

  def follow(user)
    following << user unless following.include?(user) || user == self
  end

  def unfollow(user)
    following.delete(user)
  end

  def following?(user)
    following.include?(user)
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20] # random password
      # user.name = auth.info.name
    end
  end
end
