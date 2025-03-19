# frozen_string_literal: true

module UrlCommand
  class Create
    prepend SimpleCommand

    def initialize(params)
      @params = params
    end

    def call
      url = Url.new(@params)
      url.short_url = Url.generate_short_url
      url.access_count = 0

      if url.save
        OpenStruct.new(success?: true, result: url).result
      else
        OpenStruct.new(success?: false, errors: url.errors.full_messages).result
      end
    end
  end
end
