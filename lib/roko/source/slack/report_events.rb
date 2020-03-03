# frozen_string_literal: true

require 'slack-ruby-client'

require_relative 'events'
require_relative 'event_adapter'
require 'roko/source/base/report_events'

# alias for Slack module defined in slack-ruby-client
SlackClient = Slack

module Roko
  module Source
    module Slack
      # report events from slack
      class ReportEvents < Roko::Source::Base::ReportEvents
        def client
          SlackClient.configure do |config|
            config.token = ENV['SLACK_API_TOKEN']
          end
          SlackClient::Web::Client.new
        end

        def fetch_service_event(client)
          date = @start.strftime('%Y/%m/%d')
          result = client.auth_test
          client
            .search_messages({
                               query: "from:@#{result.user} on:#{date}",
                               sort: 'timestamp'
                             })
            .messages
            .matches
        end

        def to_report_event(event)
          EventAdapter.to_report_event(event)
        end
      end
    end
  end
end
