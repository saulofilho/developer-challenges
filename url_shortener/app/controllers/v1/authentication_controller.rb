# frozen_string_literal: true

module V1
  class AuthenticationController < ApplicationController
    skip_before_action :authenticate_user, only: [:login]

    def login
      user = User.find_by(email: params[:email])

      if user&.authenticate(params[:password])
        token = JsonWebToken.encode(user_id: user.id)
        render json: { token: token, user: user.slice(:id, :email) }
      else
        render json: { error: 'Email ou senha inválidos' }, status: :unauthorized
      end
    end
  end
end
