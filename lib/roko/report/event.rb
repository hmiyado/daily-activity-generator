# frozen_string_literal: true

module Roko
  module Report
    class Event
      attr_reader :source, :created_at, :main, :sub

      # @param source [String]
      # @param created_at [Time]
      # @param main [Roko::Report::Entry]
      # @param sub [Roko::Report::Entry]
      def initialize(source, created_at, main, sub)
        @source = source
        @created_at = created_at
        @main = main
        @sub = sub
      end
    end
  end
end