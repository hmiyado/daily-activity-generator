# frozen_string_literal: true

module DailyReportGenerator
  module Source
    module Slack
      # access github events
      class Events
        def initialize(client)
          @client = client
        end

        def fetch
          @client.auth_test
        end
      end
    end
  end
end
