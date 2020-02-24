# frozen_string_literal: true

require 'time'
require 'octokit'
require 'daily_report_generator/github/events'
require 'daily_report_generator/github/event_adapter'

module DailyReportGenerator
  module ReportSource
    class << self
      def github_events
        octokit = Octokit::Client.new(netrc: true)
        github_events = DailyReportGenerator::Github::Events.new(octokit).fetch
        report_events = DailyReportGenerator::Github::EventAdapter.from(github_events)
      end

      def today
        now = Time.now
        github_events = github_events()
        github_events.filter { |event| event.created_at.year == now.year && event.created_at.month == now.month && event.created_at.day == now.day }
      end
    end
  end
end
