module DailyReportGenerator
    class Github
        def initialize(client)
            @client = client
            @login = client.login
        end
    end
end