# frozen_string_literal: true

require 'roko/report_event'
require 'time'

module Roko
  module Source
    module Github
      # convert from Github event [Sawyer::Resource] to [Roko::ReportEvent]
      module EventAdapter
        class << self
          # @param event [Sawyer::Resource]
          # @return [Roko::ReportEvent] or nil
          def to_report_event(event)
            created_at = extract_created_at(event)
            payload = extract_from_payload(event.type, event.payload)
            return nil if payload.nil? || created_at.nil?

            Roko::ReportEvent.new(
              'github',
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
