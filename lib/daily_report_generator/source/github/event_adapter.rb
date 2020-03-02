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
          # @return [DailyReportGenerator::ReportEvent] or nil
          def from_event(event)
            source = 'github'
            created_at = extract_created_at(event)
            return nil if created_at.nil?

            payload = extract_from_payload(
              event.type,
              event.payload
            )
            return nil if payload.nil?

            DailyReportGenerator::ReportEvent.new(
              source,
              payload[:event_type],
              created_at,
              payload[:url],
              payload[:summary],
              payload[:detail]
            )
          end

          # @param [Sawyer::Resource]
          # @return [Time] or nil if created_at is not present
          def extract_created_at(event)
            created_at = event.created_at
            if created_at.instance_of? Time
              created_at
            elsif created_at.instance_of? String
              Time.parse(created_at)
            end
          end

          # @param event_type [String] github event type name
          # @param payload [Hash] github event payload
          # @return [String, String, String, String]
          def extract_from_payload(event_type, payload)
            case event_type
            when 'PullRequestReviewCommentEvent' then
              { event_type: 'PR review',
                url: payload.comment.html_url,
                summary: payload.pull_request.title.to_s,
                detail: payload.comment.body }
            when 'PullRequestEvent' then
              { event_type: "PR #{payload.action}",
                url: payload.pull_request.html_url,
                summary: payload.pull_request.title.to_s,
                detail: payload.pull_request.body }
            when 'CreateEvent' then
              { event_type: 'create',
                url: '',
                summary: "#{payload.ref_type} #{payload.ref}",
                detail: '' }
            when 'DeleteEvent' then
              { event_type: 'delete',
                url: '',
                summary: "#{payload.ref_type} #{payload.ref}",
                detail: '' }
            when 'PushEvent'
              nil
            end
          end
        end
      end
    end
  end
end
