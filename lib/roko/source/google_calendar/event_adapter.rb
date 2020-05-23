# frozen_string_literal: true

require 'roko/report/event'
require 'roko/report/entry'
require 'time'

module Roko
  module Source
    module GoogleCalendar
      module EventAdapter
        class << self
          # @param event [Google::Apis::CalendarV3::Event]
          # @return [Roko::Report::Event]
          def to_report_event(event)
            # [Google::Apis::CalendarV3::EventDateTime]
            start = event.start
            return nil if start.nil?

            Roko::Report::Event.new(
              'Google Calendar',
              created_at(start),
              Roko::Report::Entry.new('MTG', event.summary, event.html_link),
              Roko::Report::Entry.new('start', '', '')
            )
          end

          private

          # @param start [Google::Apis::CalendarV3::EventDateTime]
          # @return [Time]
          def created_at(start)
            if start.date_time.nil?
              Time.parse(start.date.to_s)
            else
              Time.parse(start.date_time.to_s)
            end
          end
        end
      end
    end
  end
end
