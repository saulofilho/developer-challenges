# frozen_string_literal: true

class AccessSerializer < Panko::Serializer
  attributes :id, :accessed_at, :created_at, :updated_at
end
