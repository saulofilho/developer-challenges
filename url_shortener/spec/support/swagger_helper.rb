# frozen_string_literal: true

module Swagger
  module ExampleSchemaHelpers
    def schema_with_exceptions(items)
      {
        allOf: [
          { '$ref' => '#/components/schemas/error_response' },
          { properties: { errors: { items: } } }
        ]
      }
    end

    def schema_with_object(object_name, ref)
      {
        type: :object,
        properties: {
          object_name => {
            '$ref' => ref
          }
        },
        required: [ object_name ]
      }
    end

    def schema_with_objects(object_name, ref)
      {
        type: :object,
        properties: {
          object_name => {
            type: :array,
            items: { '$ref' => ref }
          }
        }
      }
    end
  end
end

RSpec.configure do |config|
  config.extend Swagger::ExampleSchemaHelpers, type: :request
end
