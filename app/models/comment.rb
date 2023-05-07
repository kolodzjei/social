# frozen_string_literal: true

class Comment < ApplicationRecord
  include Likeable

  belongs_to :user
  belongs_to :post

  has_many :replies, dependent: :destroy

  has_rich_text :content

  validates :content, presence: true, length: { maximum: 500 }
  validates :user_id, :post_id, presence: true
end
