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

  has_many :notifications, dependent: :destroy

  has_one_attached :avatar do |attachable|
    attachable.variant(:thumb, resize_and_pad: [50, 50])
    attachable.variant(:medium, resize_and_pad: [300, 300])
    attachable.variant(:large, resize_and_pad: [500, 500])
  end

  before_create :set_default_avatar

  validates :avatar,
    attached: false,
    content_type: { in: ["png", "jpg", "jpeg"], message: "must be a valid image format" },
    size: { less_than: 5.megabytes, message: "should be less than 5MB" }

  validates :display_name, length: { maximum: 15, minimum: 3 }, allow_blank: true

  def follow(user)
    following << user unless following.include?(user) || user == self
  end

  def unfollow(user)
    following.delete(user)
  end

  def following?(user)
    following.include?(user)
  end

  def require_password?
    super && provider.blank?
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20] # random password
    end
  end

  private

  def set_default_avatar
    unless avatar.attached?
      avatar.attach(
        io: File.open(
          Rails.root.join(
            "app", "assets", "images", "default_avatar.png"
          ),
        ),
        filename: "default_avatar.png",
        content_type: "image/png",
      )
    end
  end
end
