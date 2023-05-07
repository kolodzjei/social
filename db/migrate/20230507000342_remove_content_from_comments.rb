# frozen_string_literal: true

class RemoveContentFromComments < ActiveRecord::Migration[7.0]
  def change
    remove_column(:comments, :content, :text)
  end
end
