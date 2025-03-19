# frozen_string_literal: true

module V1
  class UrlsController < ApplicationController
    before_action :find_url, only: [:show]

    def show
      command = UrlCommand::Show.call(@url)
      if command.success?
        redirect_to command.result.original_url, allow_other_host: true
      else
        render json: { error: 'URL has expired' }, status: :not_found
      end
    end

    def create
      command = UrlCommand::Create.call(url_params)
      if command.success?
        render json: { url: UrlSerializer.new.serialize(command.result) }, status: :created
      else
        render json: { error: command.errors.join(', ') }, status: :unprocessable_entity
      end
    end

    private

    def url_params
      params.expect(url: %i[original_url expiration_date])
    end

    def find_url
      @url = Url.find_by(short_url: params[:short_url])
      render json: { error: 'URL not found' }, status: :not_found unless @url
    end
  end
end
