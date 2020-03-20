# frozen_string_literal: true

module Roko
  DEFAULT_ONELINE_TEMPLATE = '%{Y}/%{m}/%{d} %{H}:%{M} %{event_type} [%{summary}](%{url})'

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

    def oneline_template
      env_template = ENV.fetch('ROKO_ONELINE_TEMPLATE', '')
      return env_template unless env_template.nil? || env_template.empty?

      DEFAULT_ONELINE_TEMPLATE
    end

    def oneline
      format(oneline_template, time_hash.merge(content_hash))
    end

    private

    def time_hash
      time = @created_at.getlocal
      {
        Y: time.year,
        m: time.strftime('%m'),
        d: time.strftime('%d'),
        H: time.strftime('%H'),
        M: time.strftime('%M')
      }
    end

    def content_hash
      oneline_summary = @summary.gsub("\n", ' ')
      {
        event_type: @event_type,
        summary: oneline_summary,
        url: @url,
        detail: @detail
      }
    end
  end
end
