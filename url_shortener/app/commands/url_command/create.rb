# frozen_string_literal: true

module UrlCommand
  class Create
    prepend SimpleCommand

    def initialize(params)
      @params = params
    end

    def call
      url = Url.new(@params)
      url.save!
      url
    end
  end
end
