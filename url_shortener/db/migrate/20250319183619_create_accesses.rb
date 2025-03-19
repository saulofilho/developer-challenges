# frozen_string_literal: true

class CreateAccesses < ActiveRecord::Migration[8.0]
  def change
    create_table :accesses do |t|
      t.references :url, null: false, foreign_key: true
      t.datetime :accessed_at

      t.timestamps
    end
  end
end
