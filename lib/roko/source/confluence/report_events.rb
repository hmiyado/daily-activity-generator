# frozen_string_literal: true

require_relative 'events'
require_relative 'event_adapter'
require 'roko/source/configurable'

module Roko
  module Source
    module Confluence
      # report events from confluence
      class ReportEvents
        include Roko::Source::Configurable

        def initialize(configurable = nil)
          configure_with(configurable) unless configurable.nil?
          @client = Faraday.new(url: ENV['CONFLUENCE_URL']) do |conn|
            conn.basic_auth(ENV['CONFLUENCE_USER'], ENV['CONFLUENCE_PASSWORD'])
            conn.response :json, parser_options: { object_class: OpenStruct }
          end
        end

        def fetch
          events = Events.new(@client).fetch
          EventAdapter.from(events)
        end
      end
    end
  end
end
