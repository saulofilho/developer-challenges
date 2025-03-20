# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UrlCommand::Create, type: :command do
  describe '#call' do
    context 'when the parameters are valid' do
      let(:params) { { original_url: 'https://example.com', expiration_date: 1.week.from_now } }

      it 'creates a new URL with a short_url and access_count set to 0' do
        command = described_class.new(params)
        result = command.call

        expect(result).to be_present
        expect(result.success?).to be true
        expect(result.result).to be_a(Url)
        expect(result.result.short_url).to be_present
        expect(result.result.access_count).to eq(0)
      end
    end

    context 'when the parameters are invalid' do
      let(:params) { { original_url: '' } }

      it 'does not create a URL and returns errors' do
        command = described_class.new(params)
        result = command.call

        expect(result.result).to be_present
        expect(result.result.success?).to be false
        expect(result.result.errors).to be_present
      end
    end
  end
end
