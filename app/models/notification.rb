# frozen_string_literal: true

class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :target, polymorphic: true
  belongs_to :actor, class_name: "User"

  validates :content, :user, :target, presence: true

  scope :latest, -> { order(created_at: :desc) }

  def message
    "#{display_name(actor)} #{content}"
  end

  delegate :display_name, to: "ApplicationController.helpers"
end
