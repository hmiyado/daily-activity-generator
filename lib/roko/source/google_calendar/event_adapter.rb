# frozen_string_literal: true

require 'roko/report_event'
require 'time'

module Roko
  module Source
    module GoogleCalendar
      module EventAdapter
        class << self
          # @param event [Google::Apis::CalendarV3::Event]
          # @return [Roko::ReportEvent]
          def to_report_event(event)
            source = 'google calendar'
            event_type = 'MTG'
            # [Google::Apis::CalendarV3::EventDateTime]
            start = event.start
            return nil if start.nil?

            created_at = if start.date_time.nil?
                           Time.parse(start.date.to_s)
                         else
                           Time.parse(start.date_time.to_s)
                         end

            url = event.html_link
            summary = event.summary
            detail = event.description
            Roko::ReportEvent.new(source, event_type, created_at, url, summary, detail)
          end
        end
      end
    end
  end
end
