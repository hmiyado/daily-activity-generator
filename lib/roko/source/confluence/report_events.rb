# frozen_string_literal: true

require_relative 'events'
require 'roko/source/configurable'

module Roko
  module Source
    module Confluence
      # report events from confluence
      class ReportEvents
        include Roko::Source::Configurable

        def initialize(configurable = nil)
          configure_with(configurable) unless configurable.nil?
          @client = Faraday.new(url: 'https://' + ENV['CONFLUENCE_HOST']) do |conn|
            conn.basic_auth(ENV['CONFLUENCE_USER'], ENV['CONFLUENCE_PASSWORD'])
            conn.response :json
          end
        end

        def fetch
          Events.new(@client).fetch
        end
      end
    end
  end
end
