# frozen_string_literal: true

require 'time'
require 'pry'
require 'daily_report_generator/source/github/report_events'
require 'daily_report_generator/source/google_calendar/report_events'

module DailyReportGenerator
  module Source
    # daily report events from several sources
    module Events
      class << self
        def github
          Github::ReportEvents.new.fetch
        end

        def google_calendar
          GoogleCalendar::ReportEvents.new.fetch
        end

        def today
          now = Time.now
          github_events = github()
          github_events.filter do |event|
            created_at_local = event.created_at.getlocal
            created_at_local.year == now.year && created_at_local.month == now.month && created_at_local.day == now.day
          end
        end
      end
    end
  end
end
