# frozen_string_literal: true

class Access < ApplicationRecord
  belongs_to :url
  validates :accessed_at, presence: true
end
