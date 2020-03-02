# frozen_string_literal: true

# https://github.com/gsuitedevs/ruby-samples/blob/master/calendar/quickstart/quickstart.rb

require 'google/apis/calendar_v3'
require 'googleauth'
require 'googleauth/stores/file_token_store'
require 'date'
require 'fileutils'

module DailyReportGenerator
  module GoogleCalendar
    OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'
    APPLICATION_NAME = 'hmiyado/daily_report_generator'
    CREDENTIALS_PATH = '~/credentials.json'
    # The file token.yaml stores the user's access and refresh tokens, and is
    # created automatically when the authorization flow completes for the first
    # time.
    TOKEN_PATH = 'tmp/token.yaml'
    SCOPE = Google::Apis::CalendarV3::AUTH_CALENDAR_READONLY

    # client for google calendar
    class Events
      def initialize
        @service = Google::Apis::CalendarV3::CalendarService.new
        @service.client_options.application_name = APPLICATION_NAME
        @service.authorization = authorize
      end

      # fetch google calendar events
      # @return [Google::Apis::CalendarV3::Events]
      def fetch
        calendar_id = 'primary'
        response = @service.list_events(calendar_id)
      end

      private

      def authorize
        client_id = Google::Auth::ClientId.from_file File.expand_path(CREDENTIALS_PATH)
        token_store = Google::Auth::Stores::FileTokenStore.new file: TOKEN_PATH
        authorizer = Google::Auth::UserAuthorizer.new client_id, SCOPE, token_store
        user_id = 'default'
        credentials = authorizer.get_credentials user_id
        if credentials.nil?
          url = authorizer.get_authorization_url base_url: OOB_URI
          puts 'Open the following URL in the browser and enter the ' \
               "resulting code after authorization:\n" + url
          code = gets
          credentials = authorizer.get_and_store_credentials_from_code(
            user_id: user_id, code: code, base_url: OOB_URI
          )
        end
        credentials
      end
    end
  end
end
