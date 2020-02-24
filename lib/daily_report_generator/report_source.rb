# frozen_string_literal: true

require 'octokit'
require 'daily_report_generator/github/events'
require 'daily_report_generator/github/event_adapter'

module DailyReportGenerator
  module ReportSource
    class << self
      def github_events
        octokit = Octokit::Client.new(netrc: true)
        github_events = DailyReportGenerator::Github::Events.new(octokit).fetch
        DailyReportGenerator::Github::EventAdapter.from(github_events)
      end
    end
  end
end
