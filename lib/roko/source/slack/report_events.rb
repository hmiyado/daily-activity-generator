# frozen_string_literal: true

require 'slack-ruby-client'

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
          user = my_user(client)
          after = Date.parse(@start.to_s).prev_day.to_s
          before = Date.parse(@end.to_s).to_s
          query = "from:@#{user} after:#{after} before:#{before}"
          search_messages(client, query)
        end

        def to_report_event(event)
          EventAdapter.to_report_event(event)
        end

        private

        def my_user(client)
          client.auth_test.user
        end

        def search_messages(client, query)
          client
            .search_messages({
                               query: query,
                               count: 100,
                               sort: 'timestamp'
                             })
            .messages
            .matches
        end
      end
    end
  end
end
