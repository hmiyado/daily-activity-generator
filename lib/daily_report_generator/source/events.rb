# frozen_string_literal: true

require 'time'
require 'pry'
require 'daily_report_generator/source/github/report_events'
require 'daily_report_generator/source/google_calendar/report_events'
require 'daily_report_generator/source/slack/report_events'
require_relative 'configurable'

module DailyReportGenerator
  module Source
    # daily report events from several sources
    module Events
      extend Configurable

      class << self
        def github
          Github::ReportEvents.new(self).fetch
        end

        def google_calendar
          GoogleCalendar::ReportEvents.new(self).fetch
        end

        def slack
          Slack::ReportEvents.new(self).fetch
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
