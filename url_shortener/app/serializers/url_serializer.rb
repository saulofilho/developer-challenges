# frozen_string_literal: true

class UrlSerializer < Panko::Serializer
  attributes :id, :original_url, :short_url, :access_count, :expiration_date, :created_at, :updated_at

  has_many :accesses, serializer: AccessSerializer
end
