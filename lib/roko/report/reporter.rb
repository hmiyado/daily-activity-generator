# frozen_string_literal: true

require 'roko/report/configurable'

module Roko
  module Report
    MAX_SUMMARY_TEXT_LENGTH = 20

    class Reporter
      include Roko::Report::Configurable

      # @param event [Roko::Report::Event]
      # @return [String] formatted event
      def format(event)
        Kernel.format(
          format_template,
          event_hash(event)
        )
      end

      private

      def event_hash(event)
        {
          source: event.source
        }.merge(time_hash(event.created_at))
          .merge(entry_hash(:main, event.main))
          .merge(entry_hash(:sub, event.sub))
      end

      # @param time [Time]
      # @return [Hash]
      def time_hash(time)
        local_time = time.getlocal
        {
          Y: local_time.year,
          m: local_time.strftime('%m'),
          d: local_time.strftime('%d'),
          H: local_time.strftime('%H'),
          M: local_time.strftime('%M')
        }
      end

      # @param prefix [Symbol]
      # @param entry [Roko::Report::Entry]
      # @return [Hash]
      def entry_hash(prefix, entry)
        {
          "#{prefix}_type".to_sym => entry.type,
          "#{prefix}_title".to_sym => summarize(entry.title),
          "#{prefix}_url".to_sym => entry.url
        }
      end

      private

      # @param text String
      # @return String
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
