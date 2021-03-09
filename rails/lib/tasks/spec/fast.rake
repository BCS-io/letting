# http://myronmars.to/n/dev-blog/2014/09/rspec-3-1-has-been-released

namespace :spec do
  require 'rspec/core/rake_task'

  desc 'Run all but the slow and feature specs'
  RSpec::Core::RakeTask.new('fast') do |t|
    t.exclude_pattern = 'spec/features/**/*_spec.rb'
  end

rescue LoadError
  desc 'Run all fast tests'
  task :fast do
    abort 'spec:fast rake task is not available.'
  end
end
