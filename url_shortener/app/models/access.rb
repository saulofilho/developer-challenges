class Access < ApplicationRecord
  belongs_to :url
  validates :accessed_at, presence: true
end
