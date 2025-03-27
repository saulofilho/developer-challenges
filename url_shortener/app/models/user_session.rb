# frozen_string_literal: true

class UserSession < ApplicationRecord
  belongs_to :user

  validates :user_id, presence: true
  validates :jti, presence: true, uniqueness: true
  validates :expired_at, presence: true
end
