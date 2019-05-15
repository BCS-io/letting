namespace :search_suggestions do
  desc 'Generate search suggestions from products'
  task index: :environment do
    ActiveRecord::Base
      .connection.execute('TRUNCATE TABLE search_suggestions RESTART IDENTITY;')
    SearchSuggestion.index_properties
  end
end
