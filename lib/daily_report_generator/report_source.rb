# frozen_string_literal: true

require 'time'
require 'octokit'
require 'pry'
require 'daily_report_generator/github/events'
require 'daily_report_generator/github/event_adapter'
require 'daily_report_generator/google_calendar/events'
require 'daily_report_generator/google_calendar/event_adapter'

module DailyReportGenerator
  module ReportSource
    class << self
      def github_events
        octokit = Octokit::Client.new(netrc: true)
        github_events = DailyReportGenerator::Github::Events.new(octokit).fetch
        report_events = DailyReportGenerator::Github::EventAdapter.from(github_events)
      end

      def google_calendar_events
        google_calendar_events = DailyReportGenerator::GoogleCalendar::Events.new().fetch
        DailyReportGenerator::GoogleCalendar::EventAdapter.from(google_calendar_events.items)
      end

      def today
        now = Time.now
        github_events = github_events()
        github_events.filter do |event|
          created_at_local = event.created_at.getlocal
          created_at_local.year == now.year && created_at_local.month == now.month && created_at_local.day == now.day
        end
      end
    end
  end
end
