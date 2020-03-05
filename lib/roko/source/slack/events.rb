# frozen_string_literal: true

module Roko
  module Source
    module Slack
      # access slack events
      #
      # @!attribute [Slack::Web::Client] client
      class Events
        DEFAULT_MESSAGE_COUNT_PER_PAGE = 100

        # @param client [Faraday::Connection]
        def initialize(client)
          @client = client
        end

        # @param start_date [String]
        # @param end_date [String]
        def fetch(start_date, end_date)
          user = my_user
          after = Date.parse(start_date).prev_day.to_s
          before = Date.parse(end_date).to_s
          query = "from:@#{user} after:#{after} before:#{before}"
          search_all_messages(query)
        end

        private

        def my_user
          @client.auth_test.user
        end

        # @param query [String] search query
        def search_all_messages(query)
          first_page = search_messages_per_page(query, 1)
          total_page_count = first_page.pagination.page_count

          return first_page.matches if total_page_count == 1

          all_messages = first_page.matches
          (2..total_page_count).each do |page_index|
            page = search_messages_per_page(query, page_index)
            all_messages.concat page.matches
          end
          all_messages
        end

        # @param query [String] search query
        # @param page [Int] page
        # @see https://api.slack.com/methods/search.messages
        # @see https://github.com/slack-ruby/slack-ruby-client/blob/master/lib/slack/web/api/endpoints/search.rb
        def search_messages_per_page(query, page)
          @client
            .search_messages({
                               query: query,
                               page: page,
                               count: DEFAULT_MESSAGE_COUNT_PER_PAGE,
                               sort: 'timestamp'
                             })
            .messages
        end
      end
    end
  end
end
