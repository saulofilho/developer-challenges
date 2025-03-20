# frozen_string_literal: true

class AccessSerializer < Panko::Serializer
  attributes :id, :url_id, :accessed_at, :created_at, :updated_at
end
