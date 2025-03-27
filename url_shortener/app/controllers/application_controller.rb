# frozen_string_literal: true

class ApplicationController < ActionController::API
  before_action :authenticate_user

  private

  def authenticate_user
    header = request.headers['Authorization']
    token = header.split.last if header.present?

    decoded = JsonWebToken.decode(token)

    if decoded
      @current_user = User.find_by(id: decoded[:user_id])
      session_valid = @current_user&.user_sessions&.exists?(jti: decoded[:jti])
    end

    return if @current_user && session_valid

    render json: { error: 'Unauthorized' }, status: :unauthorized
  end
end
