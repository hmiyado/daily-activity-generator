# frozen_string_literal: true

require 'daily_report_generator/report_event'
require 'time'

module DailyReportGenerator
  module Source
    module Slack
      module EventAdapter
        MAX_SUMMARY_TEXT_LENGTH=20
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

            created_at = Time.at(event.ts.to_i)

            url = event.permalink
            text = event.text

            summary_text = if text.length > MAX_SUMMARY_TEXT_LENGTH
                text[0,MAX_SUMMARY_TEXT_LENGTH] + "..."
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
