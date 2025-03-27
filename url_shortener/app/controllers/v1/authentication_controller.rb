# frozen_string_literal: true

module V1
  class AuthenticationController < ApplicationController
    skip_before_action :authenticate_user, only: [ :login ]

    def login
      user = User.find_by(email: params[:email])

      if user&.authenticate(params[:password])
        token = JsonWebToken.encode(user_id: user.id)
        render json: { authentication_response: { token:, user: user.slice(:id, :email) } }
      else
        render json: { error: 'Invalid email or password' }, status: :unauthorized
      end
    end

    def logout
      token = request.headers['Authorization'].split.last
      decoded = JsonWebToken.decode(token)

      @current_user = User.find_by(id: decoded[:user_id])

      unless @current_user
        render json: { error: 'User not found' }, status: :not_found
        return
      end

      user_session = @current_user.user_sessions.find_by(jti: decoded[:jti])

      if user_session.nil?
        render json: { error: 'User session not found' }, status: :not_found
        return
      end

      user_session.destroy

      head :no_content
    end
  end
end
