# frozen_string_literal: true

module V1
  class ProtectedController < ApplicationController
    def index
      render json: { message: "Você está autenticado!", user: @current_user }
    end
  end
end
