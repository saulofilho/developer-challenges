# frozen_string_literal: true

class CreateUrls < ActiveRecord::Migration[8.0]
  def change
    create_table :urls do |t|
      t.string :original_url
      t.string :short_url
      t.integer :access_count, default: 0
      t.datetime :expiration_date

      t.timestamps
    end
  end
end
