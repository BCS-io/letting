require 'csv'
require_relative '../../csv/csv_transform'
require_relative '../../import/file_header'
require_relative '../../import/accounts/import_account'

STDOUT.sync = true

namespace :db do
  namespace :import do
    desc 'Import accounting information from CSV file'
    task :accounts, [:range] => :environment do |_task, args|
      DB::ImportAccount.import staging_accounts,
                               range: Rangify.from_str(args.range).to_i
    end

    def staging_accounts
      DB::CSVTransform.new(
        file_name: 'import_data/staging/staging_acc_items.csv',
        headers: DB::FileHeader.account
      ).to_a
    end
  end
end
