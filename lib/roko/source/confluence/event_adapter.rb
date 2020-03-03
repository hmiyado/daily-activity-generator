# frozen_string_literal: true

require 'roko/report_event'
require 'time'

module Roko
  module Source
    module Confluence
      # convert from Confluence event to [Roko::ReportEvent]
      module EventAdapter
        class << self
          # @param event [Hash]
          # @return [Roko::ReportEvent] or nil
          def to_report_event(event)
            created_at = Time.parse(event.metadata.currentuser.lastmodified.version.when)
            url = "#{ENV['CONFLUENCE_URL']}#{event._links.webui}"

            Roko::ReportEvent.new(
              'confluence',
              'document',
              created_at,
              url,
              event.title,
              ''
            )
          end
        end
      end
    end
  end
end
