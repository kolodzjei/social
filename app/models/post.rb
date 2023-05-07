# frozen_string_literal: true

class Post < ApplicationRecord
  include Likeable

  belongs_to :user

  has_many :comments, dependent: :destroy

  has_rich_text :content

  validates :content, presence: true, length: { maximum: 500 }
  validates :user_id, presence: true
end
