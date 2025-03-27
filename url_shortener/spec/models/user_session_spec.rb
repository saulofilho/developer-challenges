# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserSession, type: :model do
  let(:user) { create(:user) }
  let(:jti) { SecureRandom.uuid }
  let!(:session) { create(:user_session, user:, jti:, expired_at: 1.day.from_now) }
  let(:token) { JsonWebToken.encode(user_id: user.id, jti:) }

  it 'allows authentication if the session exists' do
    decoded = JsonWebToken.decode(token)
    expect(user.user_sessions).to exist(jti: decoded[:jti])
  end

  it 'denies authentication if the session has been revoked' do
    session.destroy
    user.reload
    JsonWebToken.decode(token)
    expect(user.user_sessions).not_to exist(jti: session.jti)
  end
end
