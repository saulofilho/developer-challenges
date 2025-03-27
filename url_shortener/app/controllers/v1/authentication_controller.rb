# frozen_string_literal: true

module V1
  class AuthenticationController < ApplicationController
    skip_before_action :authenticate_user, only: [ :login ]

    def login
      user = User.find_by(email: params[:email])

      if user&.authenticate(params[:password])
        token = JsonWebToken.encode(user_id: user.id)
        render json: { token:, user: user.slice(:id, :email) }
      else
        render json: { error: 'Invalid email or password' }, status: :unauthorized
      end
    end

    def logout
      header = request.headers['Authorization']
      token = header.split.last if header.present?
      decoded = JsonWebToken.decode(token)

      if decoded
        @current_user = User.find_by(id: decoded[:user_id])
        @current_user.user_sessions.find_by(jti: decoded[:jti])&.destroy
      end

      head :no_content
    end
  end
end
