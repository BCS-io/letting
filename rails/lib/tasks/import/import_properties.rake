require 'csv'
require_relative '../../csv/csv_transform'
require_relative '../../import/file_header'
require_relative '../../import/import_property'

STDOUT.sync = true

#
# import_properties.rake
#
# Imports csv document and generates property objects.
#
# CSV files are converted into an 2D array indexed by row number
# and header symbols and passed to ImportProperty.import which
# builds and update Property objects.
#
namespace :db do
  namespace :import do
    desc 'Import properties data from CSV file'
    task :properties, [:range] => :environment do |_task, args|
      DB::ImportProperty.import staging_properties,
                                range: Rangify.from_str(args.range).to_i
    end

    # csv file => an array of arrays.
    # Elements of the array are indexed by symbols taken
    # from the row header.
    #
    def staging_properties
      DB::CSVTransform.new(
        file_name: 'import_data/staging/staging_properties.csv',
        headers: DB::FileHeader.property
      ).to_a
    end
  end
end
