# frozen_string_literal: true

require 'daily_report_generator/report_event'

module DailyReportGenerator
  module Github
    module EventAdapter
      class << self
        # @param event [Array<Sawyer::Resource>]
        # @return [Array<DailyReportGenerator::ReportEvent>]
        def from(events)
          events.map! { |event| from_event(event) }
        end

        private

        # @param event [Sawyer::Resource]
        # @return [DailyReportGenerator::ReportEvent]
        def from_event(event)
          source = 'github'
          event_type = event.type
          created_at = event.created_at
          payload = event.payload
          case event_type
          when 'PullRequestReviewCommentEvent' then
            url = payload.comment.url
            summary = 'PR Comment'
            detail = payload.comment.body
          when 'PullRequestEvent' then
            url = payload.pull_request.url
            summary = "#{payload.action} #{payload.pull_request.title}"
            detail = payload.pull_request.body
          when 'CreateEvent' then
            url = ''
            summary = "create #{payload.ref_type} #{payload.ref}"
            detail = ''
          else
            url = ''
            summary = event_type
            detail = ''
          end
          DailyReportGenerator::ReportEvent.new(source, event_type, created_at, url, summary, detail)
        end
      end
    end
  end
end
