# frozen_string_literal: true

require 'faraday'

require_relative 'events'
require_relative 'event_adapter'
require 'roko/source/base/report_events'

module Roko
  module Source
    # event from confluence
    module Confluence
      # report events from confluence
      class ReportEvents < Roko::Source::Base::ReportEvents
        def client
          Faraday.new(url: ENV['CONFLUENCE_URL']) do |conn|
            conn.basic_auth(ENV['CONFLUENCE_USER'], ENV['CONFLUENCE_PASSWORD'])
            conn.response :json, parser_options: { object_class: OpenStruct }
          end
        end

        def fetch_service_event(client)
          Events.new(client).fetch
        end

        def to_report_event(event)
          EventAdapter.to_report_event(event)
        end
      end
    end
  end
end
