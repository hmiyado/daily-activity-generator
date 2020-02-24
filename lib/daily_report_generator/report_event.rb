# frozen_string_literal: true

module DailyReportGenerator
  # ReportEvent defines event format that should be reported.
  class ReportEvent
    attr_reader :source, :event_type, :created_at, :url, :summary, :detail

    # @param source [String] Event source name
    # @param event_type [String]
    # @param create_at [Time]
    # @param url [String]
    # @param summary [String] summary for the url
    # @param detail [String] detail for the url
    def initialize(source, event_type, created_at, url, summary, detail)
      @source = source
      @event_type = event_type
      @created_at = created_at
      @url = url
      @summary = summary
      @detail = detail
    end
  end
end
