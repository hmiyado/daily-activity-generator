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
          Github::ReportEvents.new.fetch.filter do |event|
            created_at_local = event.created_at.getlocal
            created_at_local.between?(@start, @end)
          end
        end

        def google_calendar
          GoogleCalendar::ReportEvents.new(self).fetch
        end

        def all
          github_events = github
          google_calendar_events = google_calendar
          (github_events + google_calendar_events).sort_by(&:created_at)
        end
      end
    end
  end
end
