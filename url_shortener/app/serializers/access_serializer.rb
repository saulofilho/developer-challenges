# frozen_string_literal: true

class AccessSerializer < Panko::Serializer
  attributes :id, :url_id, :accessed_at, :created_at, :updated_at

  def self.sort_accesses(accesses)
    accesses.order(created_at: :desc)
  end
end
