# http://myronmars.to/n/dev-blog/2014/09/rspec-3-1-has-been-released

begin
  require 'rspec/core/rake_task'

  desc 'Run all but the slow and feature specs'
  RSpec::Core::RakeTask.new('spec:fast') do |t|
    t.exclude_pattern = 'spec/features/**/*_spec.rb'
  end

  task 'fast' => 'db:test:prepare'
rescue LoadError
  desc 'Run all fast tests'
  task 'spec:fast' do
    abort 'spec:fast rake task is not available.'
  end
end
