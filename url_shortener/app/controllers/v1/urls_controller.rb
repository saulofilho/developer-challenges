# frozen_string_literal: true

module V1
  class UrlsController < ApplicationController
    before_action :find_url, only: %i[show accesses]

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
        render json: { errors: command.result&.errors&.full_messages || ['Invalid parameters'] }, status: :unprocessable_entity
      end
    end

    def accesses
      if @url
        accesses = @url.accesses.order(created_at: :desc)
        render json: Panko::Response.new(accesses: Panko::ArraySerializer.new(accesses, each_serializer: AccessSerializer)),
               status: :ok
      else
        render json: { error: 'URL not found' }, status: :not_found
      end
    end

    private

    def url_params
      params.require(:url).permit(:original_url, :expiration_date)
    end

    def find_url
      @url = Url.find_by(short_url: params[:short_url])
      render json: { error: 'URL not found' }, status: :not_found unless @url
    end
  end
end
