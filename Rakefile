# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will
# automatically be available to Rake.

require File.expand_path('config/application', __dir__)

Rails.application.load_tasks

if %w[development test].include? Rails.env
  # Removed to avoid vulnerability
  # require 'rubocop/rake_task'
  # RuboCop::RakeTask.new
  require 'scss_lint/rake_task'
  SCSSLint::RakeTask.new
  require 'bundler/audit/task'
  Bundler::Audit::Task.new

  task audit: 'bundle:audit'
  task(:default).clear
  task default: ['bundle:audit', :scss_lint, 'spec:fast', 'spec:features']
  task test: ['spec:fast', 'spec:features']
end
