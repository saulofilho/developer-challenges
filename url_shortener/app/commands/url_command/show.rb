# frozen_string_literal: true

module UrlCommand
  class Show
    prepend SimpleCommand

    def initialize(url)
      @url = url
    end

    def call
      if @url.expiration_date && @url.expiration_date < Time.current
        errors.add(:base, 'URL has expired')
        return nil
      end

      @url.increment!(:access_count)
      @url.accesses.create!(accessed_at: Time.current)
      @url
    end

    def success?
      errors.empty?
    end

    def errors
      @errors ||= ActiveModel::Errors.new(self)
    end
  end
end
