# frozen_string_literal: true

require 'thor'
require 'roko/source/events'

module Roko
  # cli definitions
  class Cli < Thor
    package_name 'daily report generator'
    class_option :from,
                 banner: 'YYYY/mm/dd',
                 type: :string,
                 desc: 'start date of report'
    class_option :to,
                 banner: 'YYYY/mm/dd',
                 type: :string,
                 desc: 'end date of report'

    desc 'github', 'generate github daily report'
    def github
      setup_configuration
      github_events = Roko::Source::Events.github
      github_events.each { |event| puts event.oneline }
    end

    desc 'google_calendar', 'generate google calendar report'
    def google_calendar
      setup_configuration
      google_calendar_events = Roko::Source::Events.google_calendar
      google_calendar_events.each { |event| puts event.oneline }
    end

    desc 'jira', 'generate jira report'
    def jira
      setup_configuration
      events = Roko::Source::Events.jira
      events.each { |event| puts event.oneline }
    end

    desc 'slack', 'generate slack report'
    def slack
      setup_configuration
      events = Roko::Source::Events.slack
      events.map { |event| puts event.oneline }
    end

    desc 'confluence', 'generate confluence report'
    def confluence
      setup_configuration
      events = Roko::Source::Events.confluence
      events.map { |event| puts event.oneline }
    end

    desc 'all', 'generate report'
    def all
      setup_configuration

      today_events = Roko::Source::Events.all
      today_events.map { |event| puts event.oneline }
    end
    map today: :all

    private

    def setup_configuration
      Source::Events.setup(options)
    end
  end
end
