# frozen_string_literal: true

require 'octokit'

require_relative 'event_adapter'
require 'roko/source/base/report_events'

module Roko
  module Source
    module Github
      # report events from github
      class ReportEvents < Roko::Source::Base::ReportEvents
        def client
          Octokit.configure do |c|
            c.netrc_file = ENV.fetch(
              'NETRC_FILE_PATH',
              File.expand_path('~/.netrc')
            )
            c.auto_paginate = true
          end
          Octokit::Client.new(netrc: true)
        end

        def fetch_service_event(client)
          client.user_events(client.login)
        end

        def to_report_event(event)
          EventAdapter.to_report_event(event)
        end
      end
    end
  end
end
