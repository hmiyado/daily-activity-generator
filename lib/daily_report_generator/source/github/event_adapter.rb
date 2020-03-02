# frozen_string_literal: true

require 'daily_report_generator/report_event'
require 'time'

module DailyReportGenerator
  module Source
    module Github
      # convert from Github event [Sawyer::Resource] to [DailyReportGenerator::ReportEvent]
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
            created_at = if event.created_at.instance_of? Time
                           event.created_at
                         elsif event.created_at.instance_of? String
                           Time.parse(event.created_at)
                         else
                           return nil
                      end
            payload = event.payload
            case event.type
            when 'PullRequestReviewCommentEvent' then
              event_type = 'PR review'
              url = payload.comment.html_url
              summary = payload.pull_request.title.to_s
              detail = payload.comment.body
            when 'PullRequestEvent' then
              event_type = "PR #{payload.action}"
              url = payload.pull_request.html_url
              summary = payload.pull_request.title.to_s
              detail = payload.pull_request.body
            when 'CreateEvent' then
              event_type = 'create'
              url = ''
              summary = "#{payload.ref_type} #{payload.ref}"
              detail = ''
            when 'DeleteEvent' then
              event_type = 'delete'
              url = ''
              summary = "#{payload.ref_type} #{payload.ref}"
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
end
