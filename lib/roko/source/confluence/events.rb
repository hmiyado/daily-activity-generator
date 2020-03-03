# frozen_string_literal: true

module Roko
  module Source
    module Confluence
      # access Confluence events
      #
      # @!attribute [Faraday::Connection] client
      class Events
        # @param client [Faraday::Connection]
        def initialize(client)
          @client = client
        end

        def fetch
          response = @client.get(
            ENV['CONFLUENCE_API_PATH'] + '/rest/api/content/search', {
              expand: 'container,metadata.currentuser.lastmodified',
              cql: 'type in (page,blogpost) and id in recentlyModifiedPagesAndBlogPostsByUser(currentUser(), 0, 20)'
            }
          )
          response.body.results
        end
      end
    end
  end
end
