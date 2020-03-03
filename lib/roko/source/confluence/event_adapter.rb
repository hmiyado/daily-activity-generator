# frozen_string_literal: true

require 'roko/report_event'
require 'time'

module Roko
  module Source
    module Confluence
      # convert from Confluence event to [Roko::ReportEvent]
      module EventAdapter
        class << self
          # @param event [Array<Sawyer::Resource>]
          # @return [Array<Roko::ReportEvent>]
          def from(events)
            events.map! { |event| from_event(event) }.compact
          end

          private

          # @param event [Hash]
          # @return [Roko::ReportEvent] or nil
          def from_event(event)
            created_at = Time.parse(event.metadata.currentuser.lastmodified.version.when)
            url = "https://#{ENV['CONFLUENCE_HOST']}#{ENV['CONFLUENCE_API_PATH']}#{event._links.webui}"

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
