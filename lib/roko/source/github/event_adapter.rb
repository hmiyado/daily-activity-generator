# frozen_string_literal: true

require 'roko/report/event'
require 'roko/report/entry'
require 'time'

module Roko
  module Source
    module Github
      # convert from Github event [Sawyer::Resource] to [Roko::Report::Event]
      module EventAdapter
        class << self
          # @param event [Sawyer::Resource]
          # @return [Roko::Report::Event] or nil
          def to_report_event(event)
            created_at = extract_created_at(event)
            return nil if created_at.nil?
            return nil unless is_acceptable_event_type(event.type)

            Roko::Report::Event.new(
              'Github',
              created_at,
              extract_main_entry(event.payload),
              extract_sub_entry(event.type, event.payload)
            )
          end

          private

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

          # @param [String]
          # @return [Boolean]
          def is_acceptable_event_type(event_type)
            %w[PullRequestReviewCommentEvent PullRequestEvent].include? event_type
          end

          # @param [Hash]
          # @return [Roko::Report::Entry]
          def extract_main_entry(payload)
            Roko::Report::Entry.new(
              'PR',
              payload.pull_request.title.to_s,
              payload.pull_request.html_url
            )
          end

          # @param event_type [String] github event type name
          # @param payload [Hash] github event payload
          # @return [String, String, String, String]
          def extract_sub_entry(event_type, payload)
            case event_type
            when 'PullRequestReviewCommentEvent'
              Roko::Report::Entry.new(
                'review',
                payload.comment.body,
                payload.comment.html_url
              )
            when 'PullRequestEvent'
              Roko::Report::Entry.new(
                payload.action,
                '',
                ''
              )
            when 'CreateEvent'
              nil
            when 'DeleteEvent'
              nil
            when 'PushEvent'
              nil
            end
          end
        end
      end
    end
  end
end
