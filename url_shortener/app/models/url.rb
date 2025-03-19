# frozen_string_literal: true

class Url < ApplicationRecord
  has_many :accesses, dependent: :destroy

  validates :original_url, presence: true, format: { with: URI::DEFAULT_PARSER.make_regexp }
  validates :short_url, presence: true, uniqueness: true, length: { in: 5..10 }
  validate :expiration_date_valid, if: :expiration_date?

  def self.generate_short_url
    loop do
      short_url = SecureRandom.alphanumeric(8)
      return short_url unless Url.exists?(short_url:)
    end
  end

  private

  def expiration_date_valid
    return if expiration_date.nil?

    return unless expiration_date <= Time.current

    errors.add(:expiration_date, 'must be in the future')
  end
end
