# frozen_string_literal: true

require 'roko/report/event'
require 'roko/report/entry'
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
            key = event.attrs['key']
            url = "#{ENV['JIRA_URL']}#{ENV['JIRA_CONTEXT_PATH']}/browse/#{key}"

            fields = event.attrs['fields']

            summary = "[#{key}] #{fields['summary']}"
            Roko::Report::Event.new(
              'JIRA',
              Time.parse(fields['updated']),
              Roko::Report::Entry.new('task', summary, url),
              Roko::Report::Entry.new('edit', '', '')
            )
          end
        end
      end
    end
  end
end
