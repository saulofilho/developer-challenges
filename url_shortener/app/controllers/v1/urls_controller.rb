# frozen_string_literal: true

module V1
  class UrlsController < ApplicationController
    before_action :find_url, only: [:show]

    def show
      if @url.expiration_date && @url.expiration_date < Time.current
        render json: { error: 'URL has expired' }, status: :not_found
      else
        @url.increment!(:access_count)
        @url.accesses.create!(accessed_at: Time.current)
        redirect_to @url.original_url, allow_other_host: true
      end
    end

    def create
      url = Url.new(url_params)
      url.short_url = generate_short_url
      url.access_count = 0

      if url.save
        render json: { url: UrlSerializer.new.serialize(url) }, status: :created
      else
        render json: { error: 'Unable to create short URL' }, status: :unprocessable_entity
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

    def generate_short_url
      loop do
        short_url = SecureRandom.alphanumeric(8)
        return short_url unless Url.exists?(short_url:)
      end
    end
  end
end
