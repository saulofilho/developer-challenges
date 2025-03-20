# frozen_string_literal: true

require 'bcrypt'

class User < ApplicationRecord
  has_secure_password
  validates :email, presence: true, uniqueness: true
end
