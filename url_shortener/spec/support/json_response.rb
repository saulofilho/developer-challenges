# frozen_string_literal: true

class JsonR < OpenStruct
  delegate :keys, to: :to_h
end

module JsonResponseMethods
  def json_response
    JSON.parse(response.body, object_class: JsonR)
  rescue JSON::ParserError => e
    puts 'Failed to parse response'
    pp response.body
    raise e
  end
end

RSpec.configure do |config|
  config.include JsonResponseMethods
end
