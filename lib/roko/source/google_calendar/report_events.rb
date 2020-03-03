# frozen_string_literal: true

require_relative 'client'
require_relative 'event_adapter'
require 'roko/source/base/report_events'

module Roko
  module Source
    module GoogleCalendar
      # report events from google calendar
      class ReportEvents < Roko::Source::Base::ReportEvents
        def client
          Client.new_client
        end

        def fetch_service_event(client)
          client
            .list_events(
              'primary',
              time_min: DateTime.parse(@start.to_s).rfc3339,
              time_max: DateTime.parse(@end.to_s).rfc3339
            )
            .items
        end

        def to_report_event(event)
          EventAdapter.to_report_event(event)
        end
      end
    end
  end
end
