# frozen_string_literal: true

require 'daily_report_generator/report_event'
require 'time'

module DailyReportGenerator
  module Source
    module Slack
      module EventAdapter
        class << self
          # @param events [Array<Slack::Messages::Message>]
          # @return [Array<DailyReportGenerator::ReportEvent>]
          def from(events)
            events.map! { |event| from_event(event) }.compact
          end

          private

          # @param event [Slack::Messages::Message]
          # @return [DailyReportGenerator::ReportEvent]
          def from_event(event)
            source = 'slack'
            event_type = 'comment'

            created_at = Time.at(event.ts.to_f)

            url = event.permalink
            text = event.text
            summary_text = if text.length > 10
                text[0,10] + "..."
              else
                text
              end
              
            summary = "in ##{event.channel.name} \"#{summary_text}\""
            detail = text
            DailyReportGenerator::ReportEvent.new(source, event_type, created_at, url, summary, detail)
          end
        end
      end
    end
  end
end
