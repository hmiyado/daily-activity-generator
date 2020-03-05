# frozen_string_literal: true

module Roko
  module Source
    module Slack
      # access slack events
      #
      # @!attribute [Slack::Web::Client] client
      class Events
        # @param client [Faraday::Connection]
        def initialize(client)
          @client = client
        end

        def fetch
          user = my_user
          after = Date.parse(@start.to_s).prev_day.to_s
          before = Date.parse(@end.to_s).to_s
          query = "from:@#{user} after:#{after} before:#{before}"
          search_messages(client, query)
        end

        private

        def my_user
          @client.auth_test.user
        end

        def search_messages(query)
          @client
            .search_messages({
                               query: query,
                               count: 100,
                               sort: 'timestamp'
                             })
            .messages
            .matches
        end
      end
    end
  end
end
