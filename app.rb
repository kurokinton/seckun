require "sinatra"
require "sequel"
require "pg"
require "logger"

DB = Sequel.postgres(ENV['POSTGRES_DB'],
                            user: ENV['POSTGRES_USER'], 
                                   password: ENV['POSTGRES_PASSWORD'],
                                          host: ENV['POSTGRES_HOST'],
                                                 port: 5432, 
                                                        max_connections: 10,
                                                               logger: Logger.new(STDOUT))

unless DB.table_exists?(:counters)
    DB.create_table :counters do
          primary_key :id
              Integer :count
                end
end

counters = DB[:counters]
if counters.count == 0
    counters.insert(count: 0)
end

helpers do
    def counters
          @@counters ||= DB[:counters]
            end

      def increment_count
            counters.update(count: Sequel[:count] + 1)
              end

        def current_count
              counter = counters.first
                  counter[:count]
                    end
end

get "/" do
    increment_count
      "Hello, from Docker.\n" +
            "My Ruby version is: #{RUBY_VERSION}\n" +
                "Access Count: #{current_count}\n"
end
