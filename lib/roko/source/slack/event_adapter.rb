# frozen_string_literal: true

require 'roko/report/event'
require 'roko/report/entry'
require 'time'

module Roko
  module Source
    module Slack
      # event adapter from slack to report event
      module EventAdapter
        class << self
          # @param event [Slack::Messages::Message]
          # @return [Roko::Report::Event]
          def to_report_event(event)
            Roko::Report::Event.new(
              'Slack', Time.at(event.ts.to_i),
              Roko::Report::Entry.new('channel', "##{event.channel.name}", ''),
              Roko::Report::Entry.new('post', event.text, event.permalink)
            )
          end
        end
      end
    end
  end
end
