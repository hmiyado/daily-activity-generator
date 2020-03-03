# frozen_string_literal: true

module Roko
  module Source
    # @!attribute start
    #   @return [Time] start time of this report
    # @!attribute end
    #   @return [Time] end time of this report
    module Configurable
      attr_accessor :start, :end

      def today
        @start = Date.today.to_time
        @end = Date.today.next.to_time
      end

      def setup
        today
      end

      # @param configurable [Roko::Source::Configurable]
      def configure_with(configurable)
        @start = configurable.start
        @end = configurable.end
      end
    end
  end
end
