# frozen_string_literal: true

require 'octokit'
require 'daily_report_generator/github/events'

module DailyReportGenerator
  module ReportSource
    class << self
      def github_events
        octokit = Octokit::Client.new(netrc: true)
        events = DailyReportGenerator::Github::Events.new(octokit)
        events.fetch
      end
    end
  end
end
