# frozen_string_literal: true

require_relative 'events'
require_relative 'event_adapter'
require 'roko/source/configurable'

module Roko
  module Source
    module GoogleCalendar
      class ReportEvents
        include Roko::Source::Configurable

        def initialize(configurable)
          configure_with(configurable)
        end

        def fetch
          events = Events.new.fetch(
            DateTime.parse(@start.to_s).rfc3339,
            DateTime.parse(@end.to_s).rfc3339
          )
          EventAdapter.from(events.items)
        end
      end
    end
  end
end
