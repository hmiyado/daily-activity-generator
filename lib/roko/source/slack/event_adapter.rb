# frozen_string_literal: true

require 'roko/report_event'
require 'time'

module Roko
  module Source
    module Slack
      # event adapter from slack to report event
      module EventAdapter
        MAX_SUMMARY_TEXT_LENGTH = 20
        class << self
          # @param event [Slack::Messages::Message]
          # @return [Roko::ReportEvent]
          def to_report_event(event)
            source = 'slack'
            event_type = 'comment'

            created_at = Time.at(event.ts.to_i)

            url = event.permalink
            text = event.text

            summary_text = summarize(text)

            summary = "in ##{event.channel.name} \"#{summary_text}\""
            detail = text
            Roko::ReportEvent.new(source, event_type, created_at, url, summary, detail)
          end

          private

          def summarize(text)
            if text.length > MAX_SUMMARY_TEXT_LENGTH
              text[0, MAX_SUMMARY_TEXT_LENGTH] + '...'
            else
              text
            end
          end
        end
      end
    end
  end
end
