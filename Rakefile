begin
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new(:spec) do |task_config|
    task_config.verbose = false
  end

  task :default => :spec
rescue LoadError
end

namespace :db do
  db_folder = File.join(File.dirname(__FILE__), "spec", "db")
  db_path = File.join(db_folder, "example.db")
  schema_path = File.join(db_folder, "example.sql")

  desc "Drop and re-create the database"
  task :reset => [:drop, :create]

  desc "Create the example database for testing"
  task :create do
    puts "Creating example database"
    system("sqlite3 #{db_path} < #{schema_path}")
  end

  desc "Drop the example database for testing"
  task :drop do
    puts "Removing the example database"
    system("rm #{db_path}")
  end
end

desc 'Play with the spec database'
task "play" do
  exec "irb -r./spec/spec_helper"
end
