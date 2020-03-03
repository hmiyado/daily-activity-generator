# frozen_string_literal: true

require 'roko/source/configurable'

module Roko
  module Source
    # base module for event sources
    module Base
      # report event
      class ReportEvents
        include Roko::Source::Configurable

        def initialize(configurable = nil)
          configure_with(configurable) unless configurable.nil?
        end

        def fetch
          fetch_service_event(client)
            .map! { |event| to_report_event(event) }
            .compact
            .filter { |e| e.created_at.between?(@start, @end) }
            .sort_by(&:created_at)
        end

        private

        def client
          raise NotImplementedError
        end

        def fetch_service_event(_client)
          raise NotImplementedError
        end

        def to_report_event(_event)
          raise NotImplementedError
        end
      end
    end
  end
end
