# frozen_string_literal: true

class CreateNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table(:notifications) do |t|
      t.references(:user, null: false, foreign_key: true)
      t.references(:target, polymorphic: true, null: false)
      t.boolean(:read, default: false)
      t.string(:content, null: false)
      t.references(:actor, null: false, foreign_key: { to_table: :users })

      t.timestamps
    end
  end
end
