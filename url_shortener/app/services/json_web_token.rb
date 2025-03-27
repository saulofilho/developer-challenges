# frozen_string_literal: true

require 'jwt'

class JsonWebToken
  SECRET_KEY = Rails.application.credentials.secret_key_base

  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    payload[:jti] = SecureRandom.uuid

    user = User.find_by(id: payload[:user_id])
    user&.user_sessions&.create!(jti: payload[:jti], expired_at: exp)

    JWT.encode(payload, SECRET_KEY)
  end

  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY)[0]
    ActiveSupport::HashWithIndifferentAccess.new(decoded)
  rescue StandardError
    nil
  end
end
