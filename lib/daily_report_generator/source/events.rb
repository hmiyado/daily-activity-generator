# frozen_string_literal: true

require 'time'
require 'pry'
require 'daily_report_generator/source/github/report_events'
require 'daily_report_generator/source/google_calendar/report_events'
require_relative 'configurable'

module DailyReportGenerator
  module Source
    # daily report events from several sources
    module Events
      extend Configurable

      class << self
        def github
          setup
          Github::ReportEvents.new.fetch
        end

        def google_calendar
          setup
          GoogleCalendar::ReportEvents.new.fetch
        end

        def today
          setup
          github_events = github
          github_events.filter do |event|
            created_at_local = event.created_at.getlocal
            created_at_local.between?(@start, @end)
          end
        end
      end
    end
  end
end
