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
          created_at = Time.parse(event.start.date_time.to_s)

          url = event.html_link
          summary = event.summary
          detail = event.description
          DailyReportGenerator::ReportEvent.new(source, event_type, created_at, url, summary, detail)
        end
      end
    end
  end
end
