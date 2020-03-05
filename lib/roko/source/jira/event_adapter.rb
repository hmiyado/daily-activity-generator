# frozen_string_literal: true

require 'roko/report_event'
require 'time'

module Roko
  module Source
    module Jira
      # event adapter from jira to report event
      module EventAdapter
        class << self
          # @param event [JIRA::Resource::Issue]
          # @return [Roko::ReportEvent]
          def to_report_event(event)
            source = 'jira'
            event_type = 'ticket'

            key = event.attrs['key']
            url = "#{ENV['JIRA_URL']}#{ENV['JIRA_CONTEXT_PATH']}/browse/#{key}"

            fields = event.attrs['fields']

            created_at = Time.parse(fields['updated'])

            summary = "[#{key}] #{fields['summary']}"
            detail = fields['description']
            Roko::ReportEvent.new(source, event_type, created_at, url, summary, detail)
          end
        end
      end
    end
  end
end
