require "bundler/gem_tasks"
# require "rake/testtask"
# Bundler.require
require 'sequel'
# task :default => :test

# Rake::TestTask.new do |t|
#   t.pattern = "test/*_test.rb"
# end

namespace :db do
  desc "Run migrations"
  task :migrate => [:setup] do
    Sequel::Migrator.run(@database, "db/migrations")
  end

  desc "Reset database"
  task :reset => [:setup] do
    Sequel::Migrator.run(@database, "db/migrations", :target => 0)
    Sequel::Migrator.run(@database, "db/migrations")
  end

  task :setup do
    Sequel.extension :migration

    if ENV["TRAFFIC_SPY_ENV"] == "test"
      @database = Sequel.sqlite database_file
      database_file = 'db/traffic_spy-test.sqlite3'
    else
      @database = Sequel.postgres 'traffic_spy'
    end
  end
end

# THIS SPACE RESERVED FOR EVALUATIONS
#
#
#
#
# THIS SPACE RESERVED FOR EVALUATIONS
