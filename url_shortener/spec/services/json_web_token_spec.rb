# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JsonWebToken, type: :service do
  let(:payload) { { user_id: 1 } }
  let(:token) { described_class.encode(payload) }

  describe '.encode' do
    it 'generates a valid JWT token' do
      expect(token).to be_a(String)
    end
  end

  describe '.decode' do
    context 'with a valid token' do
      it 'decodes the token and returns the payload' do
        decoded = described_class.decode(token)
        expect(decoded[:user_id]).to eq(1)
      end
    end

    context 'with an invalid token' do
      it 'returns nil' do
        expect(described_class.decode('invalid.token')).to be_nil
      end
    end
  end
end
