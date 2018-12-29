require 'csv'
require_relative '../../csv/csv_transform'
require_relative '../../import/file_header'
require_relative '../../import/charges/import_charge'

STDOUT.sync = true

namespace :db do
  namespace :import do
    desc 'Import clients data from CSV file'
    task :charges, [:range] => :environment do |_task, args|
      DB::ImportCharge.import staging_charges,
                              range: Rangify.from_str(args.range).to_i
    end

    def staging_charges
      DB::CSVTransform.new(
        file_name: 'import_data/staging/staging_acc_info.csv',
        headers: DB::FileHeader.charge
      ).to_a
    end
  end
end
