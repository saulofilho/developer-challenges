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
          schema schema_with_object(:authentication_response, '#/components/schemas/authentication_response')

          let(:credentials) do
            {
              email: 'testuser@example.com',
              password: 'password123'
            }
          end

          before do
            user = create(:user)
          end

          run_test! do
            expect(json_response.authentication_response.token).to be_present
            expect(json_response.authentication_response.user.email).to eq('testuser@example.com')
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
          let(:user) { create(:user) }
          let(:token) { JsonWebToken.encode(user_id: user.id, jti: 'some_jti_value', exp: 24.hours.from_now.to_i) }

          it 'logs the user out and returns 204 status' do
            delete '/v1/logout', headers: { 'Authorization' => "Bearer #{token}" }

            expect(response.status).to eq(204)
          end
        end
      end

      context 'without token' do
        response 401, 'unauthorized' do
          it 'returns unauthorized error when no token is provided' do
            delete '/v1/logout', headers: {}

            expect(response.status).to eq(401)
            expect(json_response['error']).to eq('Token is missing or invalid')
          end
        end
      end

      context 'with invalid token' do
        response 401, 'unauthorized due to invalid token' do
          let(:invalid_token) { 'invalid_token' }

          it 'returns unauthorized error for invalid token' do
            delete '/v1/logout', headers: { 'Authorization' => "Bearer #{invalid_token}" }

            expect(response.status).to eq(401)
            expect(json_response['error']).to eq('Invalid token')
          end
        end
      end

      context 'with expired token' do
        response 401, 'unauthorized due to expired token' do
          let(:user) { create(:user) }
          let(:expired_token) { JsonWebToken.encode(user_id: user.id, jti: 'some_jti_value', exp: 1.year.ago.to_i) }

          before do
            allow(JsonWebToken).to receive(:decode).and_raise(JWT::ExpiredSignature)
          end
          it 'returns unauthorized error for expired token' do
            delete '/v1/logout', headers: { 'Authorization' => "Bearer #{expired_token}" }

            expect(response.status).to eq(401)
            expect(json_response['error']).to eq('Token has expired')
          end
        end
      end

      context 'with valid token but user not found' do
        response 404, 'user not found' do
          let(:non_existent_user_id) { 99999 }
          let(:token) { JsonWebToken.encode(user_id: non_existent_user_id, jti: 'some_jti_value') }

          it 'returns user not found error when the user does not exist' do
            delete '/v1/logout', headers: { 'Authorization' => "Bearer #{token}" }

            expect(response.status).to eq(404)
            expect(json_response['error']).to eq('User not found')
          end
        end
      end
    end
  end
end
