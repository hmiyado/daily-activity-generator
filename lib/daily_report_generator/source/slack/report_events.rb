# frozen_string_literal: true

require 'slack-ruby-client'

require_relative 'events'
require_relative 'event_adapter'
require 'daily_report_generator/source/configurable'

# alias for Slack module defined in slack-ruby-client
SlackClient=Slack

module DailyReportGenerator
  module Source
    module Slack
      class ReportEvents
        include DailyReportGenerator::Source::Configurable

        def initialize(configurable)
          configure_with(configurable) unless configurable.nil?

          SlackClient.configure do |config|
            config.token = ENV['SLACK_API_TOKEN']
          end
        end

        def fetch
          client = SlackClient::Web::Client.new
          events = Events.new(client).fetch(
            @start.strftime('%Y/%m/%d')
          )
          EventAdapter.from(events.messages.matches)
        end
      end
    end
  end
end
