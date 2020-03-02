# frozen_string_literal: true

require 'octokit'

require_relative 'events'
require_relative 'event_adapter'

module DailyReportGenerator
  module Source
    module Github
      class ReportEvents
        def fetch
          octokit = Octokit::Client.new(netrc: true)
          github_events = Events.new(octokit).fetch
          EventAdapter.from(github_events)
        end
      end
    end
  end
end
