namespace :style do
  require 'foodcritic'
  desc 'Run Chef style checks'
  FoodCritic::Rake::LintTask.new(:chef)
end

desc 'Run all style checks'
task style: ['style:chef']

require 'kitchen'
desc 'Run Test Kitchen integration tests'
task :integration do
  Kitchen.logger = Kitchen.default_file_logger
  Kitchen::Config.new.instances.each do |instance|
    instance.test(:always)
  end
end

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:unit) do |t|
  # t.pattern = ["spec/unit/**/*_spec.rb"]
  t.rspec_opts = ['--color --format progress']
end

# The default rake task should just run it all
task default: [:unit]

begin
  require 'kitchen/rake_tasks'
  Kitchen::RakeTasks.new
rescue LoadError
  puts ">>>>> Kitchen gem not loaded, omitting tasks" unless ENV['CI']
end
