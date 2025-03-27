# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Url, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:original_url) }
    it { should validate_uniqueness_of(:short_url) }
    it { should validate_length_of(:short_url).is_at_least(5).is_at_most(10) }

    it 'is invalid with an improperly formatted URL' do
      url = described_class.new(original_url: 'invalid_url')

      expect(url).not_to be_valid
      expect(url.errors[:original_url]).to include('is invalid')
    end

    it 'is invalid if expiration date is in the past' do
      url = described_class.new(original_url: 'https://example.com', expiration_date: 1.day.ago)

      expect(url).not_to be_valid
      expect(url.errors[:expiration_date]).to include('must be in the future')
    end
  end

  describe 'associations' do
    it { should have_many(:accesses).dependent(:destroy) }
  end

  describe '#generate_short_url' do
    it 'generates a unique short URL' do
      url = create(:url)

      expect(url.short_url).to be_present
      expect(url.short_url.length).to be_between(5, 10)
    end
  end

  describe 'callbacks' do
    context 'before validation' do
      it 'sets a short URL if none is provided' do
        url = described_class.new(original_url: 'https://example.com')

        url.valid?

        expect(url.short_url).to be_present
        expect(url.short_url.length).to be_between(5, 10)
      end

      it 'does not overwrite the short URL if one is already provided' do
        existing_short_url = 'abcd12345'
        url = described_class.new(original_url: 'https://example.com', short_url: existing_short_url)

        url.valid?

        expect(url.short_url).to eq(existing_short_url)
      end
    end
  end
end
