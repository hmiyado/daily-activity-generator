# frozen_string_literal: true

module DailyReportGenerator
  module Source
    # @!attribute start
    #   @return [Time] start time of this report
    # @!attribute end
    #   @return [Time] end time of this report
    module Configurable
      attr_accessor :start, :end

      def setup
        @start = Date.today.to_time
        @end = Date.today.next.to_time
      end
    end
  end
end
