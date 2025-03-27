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

      context 'with user authentication' do
        before do
          allow_any_instance_of(ApplicationController).to receive(:authenticate_user).and_return(true)
        end

        context 'when creating a short URL with params' do
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

        context 'when the URL is invalid' do
          response 422, 'unprocessable entity' do
            let(:url) do
              {
                url: {
                  original_url: ''
                }
              }
            end

            run_test! do
              expect(response.status).to eq(422)
              expect(json_response.error).to eq('Unprocessable Content')
            end
          end
        end

        context 'when required fields are missing' do
          response 400, 'bad request' do
            schema type: :object, properties: {
              error: { type: :string, example: 'Original URL is required' }
            }

            let(:url) do
              {
                url: {}
              }
            end

            run_test! do
              expect(response.status).to eq(400)
              expect(json_response.error).to eq('Bad Request')
            end
          end
        end
      end

      context 'without user authentication' do
        context 'when creating a short URL' do
          response 401, 'unauthorized' do
            schema type: :object, properties: {
              error: { type: :string, example: 'Token is missing or invalid' }
            }

            let(:url) do
              {
                url: {
                  original_url: 'https://www.foobar.com'
                }
              }
            end

            run_test! do
              expect(response.status).to eq(401)
              expect(json_response.error).to eq('Token is missing or invalid')
            end
          end
        end
      end
    end
  end

  path '/v1/urls/{short_url}' do
    get 'Retrieve original URL' do
      tags 'Urls'
      consumes 'application/json'
      produces 'application/json'
      operationId 'url_show'
      parameter name: :short_url, in: :path, type: :string

      context 'with user authentication' do
        before do
          allow_any_instance_of(ApplicationController).to receive(:authenticate_user).and_return(true)
        end

        context 'when accessing a valid short URL' do
          let(:url) { create(:url) }
          let(:short_url) { url.short_url }

          before do
            url.update(expiration_date: 1.day.from_now)
          end

          response 302, 'redirected to original URL' do
            run_test! do
              expect(response).to redirect_to(url.original_url)
            end
          end
        end

        context 'when accessing an expired URL' do
          url = Url.new(original_url: 'https://example.com', expiration_date: 1.day.ago)
          let(:short_url) { url.short_url }

          response 404, 'URL expired' do
            run_test! do
              expect(json_response.error).to eq('Not Found')
            end
          end
        end

        context 'when accessing a non-existent URL' do
          let(:short_url) { 'invalid123' }

          response 404, 'URL not found' do
            run_test! do
              expect(json_response.error).to eq('URL not found')
            end
          end
        end

        context 'when accessing a valid URL and checking access' do
          let(:url) { create(:url) }
          let(:short_url) { url.short_url }

          before do
            url.update(expiration_date: 1.day.from_now)
          end

          it 'increments the access count and creates an access record' do
            initial_access_count = url.access_count
            initial_accesses_count = url.accesses.count

            get "/v1/urls/#{short_url}"

            url.reload
            expect(url.access_count).to eq(initial_access_count + 1)
            expect(url.accesses.count).to eq(initial_accesses_count + 1)
          end
        end
      end

      context 'without user authentication' do
        context 'when creating a short URL' do
          let(:url) { create(:url) }
          let(:short_url) { url.short_url }

          response 401, 'unauthorized' do
            schema type: :object, properties: {
              error: { type: :string, example: 'Token is missing or invalid' }
            }

            run_test! do
              expect(response.status).to eq(401)
              expect(json_response.error).to eq('Token is missing or invalid')
            end
          end
        end
      end
    end
  end

  path '/v1/urls/{short_url}/accesses' do
    get 'Retrieve access history for short URL' do
      tags 'Urls'
      consumes 'application/json'
      produces 'application/json'
      operationId 'url_accesses'
      parameter name: :short_url, in: :path, type: :string

      context 'with user authentication' do
        before do
          allow_any_instance_of(ApplicationController).to receive(:authenticate_user).and_return(true)
        end

        context 'when accessing a URL with access history' do
          let!(:url) { create(:url) }
          let!(:short_url) { url.short_url }
          let!(:access) { create_list(:access, 3, url:) }

          response 200, 'retrieves access history' do
            schema schema_with_object(:accesses, '#/components/schemas/accesses')

            run_test! do
              expect(json_response.accesses.count).to eq(3)
              expect(json_response.accesses.first).to respond_to(:accessed_at)
            end
          end
        end

        context 'when accessing a non-existent URL' do
          let(:short_url) { 'invalid123' }

          response 404, 'URL not found' do
            run_test! do
              expect(json_response.error).to eq('URL not found')
            end
          end
        end
      end

      context 'without user authentication' do
        context 'when creating a short URL' do
          let!(:url) { create(:url) }
          let!(:short_url) { url.short_url }
          let!(:access) { create_list(:access, 3, url:) }

          response 401, 'unauthorized' do
            schema type: :object, properties: {
              error: { type: :string, example: 'Token is missing or invalid' }
            }

            run_test! do
              expect(response.status).to eq(401)
              expect(json_response.error).to eq('Token is missing or invalid')
            end
          end
        end
      end
    end
  end
end
