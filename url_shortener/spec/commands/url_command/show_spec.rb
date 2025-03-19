# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UrlCommand::Show, type: :command do
  let!(:url) { create(:url) }

  describe '#call' do
    context 'when the URL exists and is not expired' do
      it 'increments the access_count by 1' do
        initial_access_count = url.access_count

        command = described_class.new(url)
        command.call

        expect(url.reload.access_count).to eq(initial_access_count + 1)
      end
    end

    context 'when the URL is expired' do
      before do
        url.update(expiration_date: 1.day.ago)
      end

      it 'does not increment the access_count' do
        initial_access_count = url.access_count

        command = described_class.new(url)
        command.call

        expect(url.reload.access_count).to eq(initial_access_count)
      end
    end
  end
end
