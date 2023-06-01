# frozen_string_literal: true

class Conversation < ApplicationRecord
  belongs_to :sender, class_name: "User"
  belongs_to :recipient, class_name: "User"
  has_many :messages, dependent: :destroy

  validates :sender_id, uniqueness: { scope: :recipient_id }
  validates :sender, :recipient, presence: true

  scope :involving, ->(user) do
    where("conversations.sender_id = ? OR conversations.recipient_id = ?", user.id, user.id)
  end

  scope :newest, -> { order(updated_at: :desc) }

  scope :not_empty, -> { joins(:messages).distinct }
end
