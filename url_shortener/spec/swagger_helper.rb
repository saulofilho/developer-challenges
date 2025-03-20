# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|
  config.openapi_root = Rails.root.join(Settings.api.docs.root).to_s

  config.openapi_specs = {}
  Settings.api.docs.versions.each do |api_version|
    config.openapi_specs[api_version.id] = {
      openapi: api_version.openapi,
      info: {
        title: api_version.title,
        version: api_version.version
      },
      paths: {},
      servers: [
        {
          url: '{defaultHost}',
          variables: {
            defaultHost: {
              default: api_version.default_host
            }
          }
        }
      ],
      components: {
        schemas: Settings.api.schemas,
        securitySchemes: {
          bearer_auth: {
            type: :http,
            scheme: :bearer
          },
          basic_auth: {
            type: :http,
            scheme: :basic
          }
        }
      }
    }
  end

  config.openapi_format = :yaml
end
