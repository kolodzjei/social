# frozen_string_literal: true

class CreateReplies < ActiveRecord::Migration[7.0]
  def change
    create_table(:replies) do |t|
      t.references(:comment, null: false, foreign_key: true)
      t.references(:user, null: false, foreign_key: true)
      t.text(:content, null: false)
      t.references(:parent_reply, foreign_key: { to_table: :replies })
      t.timestamps
    end
  end
end
