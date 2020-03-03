# frozen_string_literal: true

require 'octokit'

require_relative 'events'
require_relative 'event_adapter'
require 'daily_report_generator/source/configurable'

module DailyReportGenerator
  module Source
    module Github
      class ReportEvents
        include DailyReportGenerator::Source::Configurable

        def initialize(configurable)
          configure_with(configurable)
          octokit = Octokit::Client.new(netrc: true)
          octokit.netrc = ENV['NETRC_FILE_PATH'] || '~/.netrc'
        end

        def fetch

          github_events = Events.new(octokit).fetch
          EventAdapter.from(github_events).filter do |event|
            created_at_local = event.created_at.getlocal
            created_at_local.between?(@start, @end)
          end
        end
      end
    end
  end
end
