# frozen_string_literal: true

class Message < ApplicationRecord
  belongs_to :user
  belongs_to :conversation

  validates :user, :conversation, presence: true
  validates :content, presence: true, length: { maximum: 500 }
end
