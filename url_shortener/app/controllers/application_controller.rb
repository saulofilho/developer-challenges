# frozen_string_literal: true

class ApplicationController < ActionController::API
  before_action :authenticate_user
  rescue_from JWT::ExpiredSignature, with: :handle_expired_token

  private

  def authenticate_user
    header = request.headers['Authorization']
    token = header.split.last if header.present?

    if token.blank?
      render json: { error: 'Token is missing or invalid' }, status: :unauthorized
      return
    end

    decoded = JsonWebToken.decode(token)

    if decoded.nil?
      render json: { error: 'Invalid token' }, status: :unauthorized
      return
    end

    exp_time = decoded[:exp]
    if exp_time.present? && Time.at(exp_time) < Time.now
      render json: { error: 'Token has expired' }, status: :unauthorized
      return
    end

    @current_user = User.find_by(id: decoded[:user_id])

    unless @current_user
      render json: { error: 'User not found' }, status: :not_found
      return
    end

    user_session = @current_user.user_sessions.find_by(jti: decoded[:jti])

    if user_session.nil?
      render json: { error: 'User session not found' }, status: :not_found
      nil
    end
  end

  def handle_expired_token
    render json: { error: 'Token has expired' }, status: :unauthorized
  end
end
