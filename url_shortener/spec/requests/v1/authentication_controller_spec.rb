# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'V1::Authentication', swagger_doc: 'v1/swagger.yaml' do
  path '/v1/login' do
    post 'User login' do
      tags 'Authentication'
      consumes 'application/json'
      produces 'application/json'
      operationId 'authentication_login'
      parameter name: :credentials, in: :body, schema: { '$ref' => '#/components/schemas/authentication_login' }

      context 'when providing valid credentials' do
        response 200, 'login successful' do
          schema type: :object, properties: {
            token: { type: :string },
            user: {
              type: :object,
              properties: {
                id: { type: :integer },
                email: { type: :string }
              }
            }
          }

          let(:credentials) do
            {
              email: 'testuser@example.com',
              password: 'password123'
            }
          end

          before do
            user = User.create!(email: 'testuser@example.com', password: 'password123')
          end

          run_test! do
            expect(json_response.token).to be_present
            expect(json_response.user.email).to eq('testuser@example.com')
          end
        end
      end

      context 'when providing invalid credentials' do
        response 401, 'unauthorized' do
          schema type: :object, properties: {
            error: { type: :string, example: 'Invalid email or password' }
          }

          let(:credentials) do
            {
              email: 'wronguser@example.com',
              password: 'wrongpassword'
            }
          end

          run_test! do
            expect(response.status).to eq(401)
            expect(json_response.error).to eq('Invalid email or password')
          end
        end
      end
    end
  end

  path '/v1/logout' do
    delete 'User logout' do
      tags 'Authentication'
      consumes 'application/json'
      produces 'application/json'
      operationId 'authentication_logout'

      context 'with valid token' do
        response 204, 'logout successful' do
          before do
            user = User.create!(email: 'testuser@example.com', password: 'password123')
            token = JsonWebToken.encode(user_id: user.id, jti: 'some_jti_value')
            allow(request).to receive(:headers).and_return({'Authorization' => "Bearer #{token}"})
            allow_any_instance_of(ApplicationController).to receive(:authenticate_user).and_return(true)
          end

          run_test! do
            expect(response.status).to eq(204)
          end
        end
      end

      context 'without token' do
        response 401, 'unauthorized' do
          before do
            allow(request).to receive(:headers).and_return({'Authorization' => nil})
          end

          run_test! do
            expect(response.status).to eq(401)
            expect(json_response.error).to eq('Unauthorized')
          end
        end
      end
    end
  end
end
