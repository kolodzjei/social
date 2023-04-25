# frozen_string_literal: true

class Comment < ApplicationRecord
  include Likeable

  belongs_to :user
  belongs_to :post

  validates :content, presence: true, length: { maximum: 100 }
  validates :user_id, presence: true
  validates :post_id, presence: true
end
