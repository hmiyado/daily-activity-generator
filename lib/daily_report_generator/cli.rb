require 'thor'
require 'daily_report_generator/report_source'

module DailyReportGenerator
    class Cli < Thor
        package_name "daily report generator"

        desc "github", "generate github daily report"
        def github
            github_events = DailyReportGenerator::ReportSource.github_events
            p github_events
        end

        desc "today", "generate today report"
        def today
            today_events = DailyReportGenerator::ReportSource.today
            p today_events
        end

    end
end