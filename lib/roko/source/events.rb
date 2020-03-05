# frozen_string_literal: true

require 'time'
require 'pry'
require 'roko/source/github/report_events'
require 'roko/source/google_calendar/report_events'
require 'roko/source/slack/report_events'
require 'roko/source/jira/report_events'
require 'roko/source/confluence/report_events'
require_relative 'configurable'

module Roko
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

        def jira
          Jira::ReportEvents.new(self).fetch
        end

        def slack
          Slack::ReportEvents.new(self).fetch
        end

        def confluence
          Confluence::ReportEvents.new(self).fetch
        end

        def all
          (github + google_calendar + slack + confluence).sort_by(&:created_at)
        end
      end
    end
  end
end
