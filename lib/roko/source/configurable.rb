# frozen_string_literal: true

require 'date'
require 'time'

module Roko
  module Source
    # @!attribute start
    #   @return [Time] start time of this report
    # @!attribute end
    #   @return [Time] end time of this report
    module Configurable
      attr_accessor :start, :end

      def setup(options)
        today = Date.today
        @start = parse_time_or_nil(options[:from]) || today.to_time
        @end = parse_time_or_nil(options[:to]) || today.next.to_time
      end

      # @param configurable [Roko::Source::Configurable]
      def configure_with(configurable)
        @start = configurable.start
        @end = configurable.end
      end

      private

      def parse_time_or_nil(str)
        Time.parse(str)
      rescue ArgumentError
        nil
      end
    end
  end
end
