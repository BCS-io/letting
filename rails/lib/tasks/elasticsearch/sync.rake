require 'elasticsearch/rails/tasks/import'

namespace :elasticsearch do
  desc 'Synchronizes elasticsearch with main database'
  task sync: :environment do
    sh "rake environment elasticsearch:import:model CLASS='Property' FORCE=y"
    sh "rake environment elasticsearch:import:model CLASS='Client' FORCE=y"
    sh "rake environment elasticsearch:import:model CLASS='Payment' FORCE=y"
  end
end
