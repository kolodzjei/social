# frozen_string_literal: true

class Post < ApplicationRecord
  include Likeable

  belongs_to :user

  has_many :comments, dependent: :destroy

  validates :content, presence: true, length: { maximum: 200 }
  validates :user_id, presence: true
end
