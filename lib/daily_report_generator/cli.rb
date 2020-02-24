require 'thor'
require 'daily_report_generator/report_source'

module DailyReportGenerator
    class Cli < Thor
        package_name "daily report generator"

        desc "github", "generate github daily report"
        def github
            today_events = DailyReportGenerator::ReportSource.today
            p today_events
        end

    end
end