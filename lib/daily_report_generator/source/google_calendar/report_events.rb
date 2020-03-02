# frozen_string_literal: true

require_relative 'events'
require_relative 'event_adapter'

module DailyReportGenerator
  module Source
    module GoogleCalendar
      class ReportEvents
        def fetch
          events = Events.new.fetch
          EventAdapter.from(events.items)
        end
      end
    end
  end
end
