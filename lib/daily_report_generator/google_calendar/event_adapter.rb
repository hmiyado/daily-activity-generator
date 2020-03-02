# frozen_string_literal: true

require 'daily_report_generator/report_event'
require 'time'

module DailyReportGenerator
  module GoogleCalendar
    module EventAdapter
      class << self
        # @param events [Array<Google::Apis::CalendarV3::Event>]
        # @return [Array<DailyReportGenerator::ReportEvent>]
        def from(events)
          events.map! { |event| from_event(event) }.compact
        end

        private

        # @param event [Google::Apis::CalendarV3::Event]
        # @return [DailyReportGenerator::ReportEvent]
        def from_event(event)
          source = 'google calendar'
          event_type = 'MTG'
          # [Google::Apis::CalendarV3::EventDateTime]
          start = event.start
          created_at = if start.date_time.nil?
                         Time.parse(start.date.to_s)
                       else
                         Time.parse(start.date_time.to_s)
                       end

          url = event.html_link
          summary = event.summary
          detail = event.description
          DailyReportGenerator::ReportEvent.new(source, event_type, created_at, url, summary, detail)
        end
      end
    end
  end
end
