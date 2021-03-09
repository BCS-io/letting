namespace :spec do
  require 'rspec/core/rake_task'

  desc 'Run all tests regardless of tags'
  RSpec::Core::RakeTask.new('all') do |task|
    task.pattern = 'spec/**/*_spec.rb'
    # Load the tagless options file
    task.rspec_opts = '-O .rspec-no-tags'
  end

rescue LoadError
  desc 'Run all tests regardless of tags'
  task :all do
    abort 'spec:all rake task is not available.'
  end
end
