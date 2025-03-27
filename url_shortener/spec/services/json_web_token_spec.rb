# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JsonWebToken, type: :service do
  let(:user) { create(:user) }
  let(:payload) { { user_id: user.id } }
  let(:token) { described_class.encode(payload) }

  describe '.encode' do
    it 'generates a valid JWT token' do
      expect(token).not_to be_nil
    end

    it 'includes a unique JTI in the payload' do
      decoded = described_class.decode(token)
      expect(decoded[:jti]).not_to be_nil
    end
  end

  describe '.decode' do
    it 'decodes a valid token' do
      decoded = described_class.decode(token)
      expect(decoded[:user_id]).to eq(user.id)
    end

    it 'returns nil for an invalid token' do
      expect(described_class.decode('invalid.token.here')).to be_nil
    end

    it 'returns nil for an expired token' do
      expired_token = described_class.encode(payload, 1.second.from_now)
      sleep 2
      expect(described_class.decode(expired_token)).to be_nil
    end
  end
end
