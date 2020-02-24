require 'thor'
require 'daily_report_generator/report_source'

module DailyReportGenerator
    class Cli < Thor
        package_name "daily report generator"

        desc "github", "generate github daily report"
        def github
            DailyReportGenerator::ReportSource.github_events
        end

    end
end