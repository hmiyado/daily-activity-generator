# frozen_string_literal: true

module DailyReportGenerator
  module Github
    # access github events
    class Events
      def initialize(client)
        @client = client
        @client.auto_paginate = true
      end

      def fetch
        @client.user_events(@client.login)
      end
    end
  end
end
