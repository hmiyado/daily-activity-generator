# frozen_string_literal: true

require 'roko/report/event'
require 'roko/report/entry'
require 'time'

module Roko
  module Source
    module Confluence
      # convert from Confluence event to [Roko::Report::Event]
      module EventAdapter
        class << self
          # @param event [Hash]
          # @return [Roko::Report::Event]
          def to_report_event(event)
            Roko::Report::Event.new(
              'Confluence',
              Time.parse(event.metadata.currentuser.lastmodified.version.when),
              main_entry(event),
              sub_entry
            )
          end

          private

          def main_entry(event)
            Roko::Report::Entry.new(
              'confluence',
              event.title,
              "#{ENV['CONFLUENCE_URL']}#{event._links.webui}"
            )
          end

          def sub_entry
            Roko::Report::Entry.new(
              'edit',
              '',
              ''
            )
          end
        end
      end
    end
  end
end
