# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'V1::Urls', swagger_doc: 'v1/swagger.yaml' do
  path '/v1/urls' do
    post 'create short URL' do
      tags 'Urls'
      consumes 'application/json'
      produces 'application/json'
      operationId 'url_create'
      parameter name: :url, in: :body, schema: { '$ref' => '#/components/schemas/url_create' }

      context 'when creating a short URL' do
        response 201, 'url created' do
          schema schema_with_object(:url, '#/components/schemas/url_response')

          let(:url) do
            {
              url: {
                original_url: 'https://www.foobar.com'
              }
            }
          end

          run_test! do
            expect(json_response.url.short_url).to be_present
            expect(json_response.url.original_url).to eq('https://www.foobar.com')
          end
        end
      end
    end
  end
end
