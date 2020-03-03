# frozen_string_literal: true

module Roko
  module Source
    module Slack
      # access slack events
      class Events
        def initialize(client)
          @client = client
        end

        def fetch(date)
          result = @client.auth_test
          @client.search_messages({
            query: "from:@#{result.user} on:#{date}",
            sort: 'timestamp'
          })
        end
      end
    end
  end
end
