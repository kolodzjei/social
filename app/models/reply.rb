# frozen_string_literal: true

class Reply < ApplicationRecord
  include Likeable

  belongs_to :comment
  belongs_to :user

  belongs_to :parent_reply, class_name: "Reply", optional: true
  has_many :replies, class_name: "Reply", foreign_key: "parent_reply_id", dependent: :destroy

  has_rich_text :content

  validates :content, presence: true, length: { maximum: 500 }
  validates :user_id, :comment_id, presence: true
end
