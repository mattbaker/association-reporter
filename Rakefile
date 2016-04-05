require 'bundler/setup'


begin
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new(:spec) do |task_config|
    task_config.verbose = false
  end

  task :default => :spec
rescue LoadError
end


desc 'Play with the spec database'
task "play" do
  exec "irb -r./repl/config"
end
