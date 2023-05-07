# frozen_string_literal: true

class Like < ApplicationRecord
  belongs_to :user
  belongs_to :likeable, polymorphic: true

  validates :user_id, :likeable_id, :likeable_type, presence: true
end
