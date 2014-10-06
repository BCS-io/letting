require 'csv'
require_relative '../../csv/csv_transform'
require_relative '../../import/file_header'
require_relative '../../import/import_client'

STDOUT.sync = true

namespace :db do
  namespace :import do

    desc 'Import clients data from CSV file'
    task clients: :environment do
      DB::ImportClient.import patched_clients
    end

    def patched_clients
      DB::CSVTransform.to_a 'staging_clients',
                            headers: DB::FileHeader.client,
                            location: 'import_data/staging'
    end
  end
end
