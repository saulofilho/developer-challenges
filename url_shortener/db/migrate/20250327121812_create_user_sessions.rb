# frozen_string_literal: true

class CreateUserSessions < ActiveRecord::Migration[8.0]
  def change
    create_table :user_sessions do |t|
      t.references :user, null: false, foreign_key: true
      t.string :jti, null: false
      t.datetime :expired_at

      t.timestamps
    end

    add_index :user_sessions, :jti, unique: true
  end
end
