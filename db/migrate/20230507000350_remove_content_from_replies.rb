# frozen_string_literal: true

class RemoveContentFromReplies < ActiveRecord::Migration[7.0]
  def change
    remove_column(:replies, :content, :text)
  end
end
