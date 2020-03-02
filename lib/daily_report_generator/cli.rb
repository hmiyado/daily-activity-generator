require 'thor'
require 'daily_report_generator/report_source'

module DailyReportGenerator
    class Cli < Thor
        package_name "daily report generator"

        desc "github", "generate github daily report"
        def github
            github_events = DailyReportGenerator::ReportSource.github_events
            github_events.each { |event| puts event.oneline }
        end

        desc "google_calendar", "generate google calendar report"
        def google_calendar
            google_calendar_events = DailyReportGenerator::ReportSource.google_calendar_events
            google_calendar_events.each { |event| puts event.oneline }
        end

        desc "today", "generate today report"
        def today
            today_events = DailyReportGenerator::ReportSource.today
            today_events.map { |event| puts event.oneline }
        end

    end
end