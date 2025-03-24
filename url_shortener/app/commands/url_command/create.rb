# frozen_string_literal: true

module UrlCommand
  class Create
    prepend SimpleCommand

    def initialize(params)
      @params = params
    end

    def call
      url = Url.new(@params.merge(short_url: Url.generate_short_url, access_count: 0))
      url.save!
      url
    end
  end
end
