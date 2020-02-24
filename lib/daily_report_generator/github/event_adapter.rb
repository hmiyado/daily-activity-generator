# frozen_string_literal: true

require 'daily_report_generator/report_event'
require 'time'

module DailyReportGenerator
  module Github
    module EventAdapter
      class << self
        # @param event [Array<Sawyer::Resource>]
        # @return [Array<DailyReportGenerator::ReportEvent>]
        def from(events)
          events.map! { |event| from_event(event) }.compact
        end

        private

        # @param event [Sawyer::Resource]
        # @return [DailyReportGenerator::ReportEvent]
        def from_event(event)
          source = 'github'
          event_type = event.type
          created_at = if event.created_at.instance_of? Time
                         event.created_at
                       elsif event.created_at.instance_of? String
                         Time.parse(event.created_at)
                       else
                         return nil
                    end
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
          when 'DeleteEvent' then
            url = ''
            summary = "delete #{payload.ref_type} #{payload.ref}"
            detail = ''
          when 'PushEvent'
            return nil
          else
            return nil
          end
          DailyReportGenerator::ReportEvent.new(source, event_type, created_at, url, summary, detail)
        end
      end
    end
  end
end
