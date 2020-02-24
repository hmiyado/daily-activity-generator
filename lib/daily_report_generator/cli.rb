require 'thor'

module DailyReportGenerator
    class Cli < Thor
        package_name "daily report generator"

        desc "github", "generate github daily report"
        def github
            say 'github'
        end

    end
end