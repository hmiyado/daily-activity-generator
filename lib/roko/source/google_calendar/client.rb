# frozen_string_literal: true

# https://github.com/gsuitedevs/ruby-samples/blob/master/calendar/quickstart/quickstart.rb

require 'google/apis/calendar_v3'
require 'googleauth'
require 'googleauth/stores/file_token_store'
require 'date'
require 'fileutils'

module Roko
  module Source
    module GoogleCalendar
      OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'
      APPLICATION_NAME = 'hmiyado/roko'
      CREDENTIALS_PATH = ENV['GOOGLE_API_CREDENTIALS_PATH'] || '~/credentials.json'
      # The file token.yaml stores the user's access and refresh tokens, and is
      # created automatically when the authorization flow completes for the first
      # time.
      TOKEN_PATH = 'tmp/token.yaml'
      SCOPE = Google::Apis::CalendarV3::AUTH_CALENDAR_READONLY
      USER_ID = 'default'

      # client for google calendar
      module Client
        def self.new_client
          service = Google::Apis::CalendarV3::CalendarService.new
          service.client_options.application_name = APPLICATION_NAME
          service.authorization = authorize
          service
        end

        def self.authorize
          Dir.mkdir('tmp') unless Dir.exist?('tmp')
          authorizer = create_authorizer
          credentials = authorizer.get_credentials USER_ID
          return credentials unless credentials.nil?

          url = authorizer.get_authorization_url base_url: OOB_URI
          puts request_authorization_message(url)
          code = STDIN.gets
          authorizer.get_and_store_credentials_from_code(
            user_id: USER_ID, code: code, base_url: OOB_URI
          )
        end

        def self.create_authorizer
          client_id = Google::Auth::ClientId.from_file File.expand_path(CREDENTIALS_PATH)
          token_store = Google::Auth::Stores::FileTokenStore.new file: TOKEN_PATH
          Google::Auth::UserAuthorizer.new client_id, SCOPE, token_store
        end

        def self.request_authorization_message(url)
          'Open the following URL in the browser and enter the ' \
               "resulting code after authorization:\n" + url
        end
      end
    end
  end
end
