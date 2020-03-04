# frozen_string_literal: true

require 'jira-ruby'
require 'roko/source/base/report_events'

module Roko
  module Source
    module Jira
      # report events from Jira
      class ReportEvents < Roko::Source::Base::ReportEvents
        def client
          options = {
            username: ENV['JIRA_USER'],
            password: ENV['JIRA_PASSWORD'],
            site: ENV['JIRA_URL'],
            context_path: ENV['JIRA_CONTEXT_PATH'],
            auth_type: :basic,
            rest_base_path: '/rest/api/2'
          }
          JIRA::Client.new(options)
        end

        # @param client [JIRA::Client]
        def fetch_service_event(client)
          jql = jql_status_changed_between(@start, @end)
          client.Issue.jql(jql)
        end

        # @param start_time [Time]
        # @param end_time [Time]
        def jql_status_changed_between(start_time, end_time)
          start_date = start_time.strftime('%Y/%m/%d')
          end_date = end_time.strftime('%Y/%m/%d')
          'status changed by currentUser()' \
            " AND updatedDate >= \"#{start_date}\"" \
            " AND updatedDate < \"#{end_date}\""
        end

        def to_report_event(event)
          event
        end
      end
    end
  end
end
