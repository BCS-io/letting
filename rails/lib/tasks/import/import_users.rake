# rubocop: disable Metrics/MethodLength
require 'csv'
require_relative '../../csv/csv_transform'
require_relative '../../import/file_header'
require_relative '../../import/import_user'

STDOUT.sync = true

namespace :db do
  namespace :import do
    desc 'Import users data from CSV file'
    task :users, [:test] => :environment do |_task, args|
      if File.exist?('import_data/new/users.csv')
        # Cannot use Guard clause users_csv is not available on travis runs!
        DB::ImportUser.import users_file
      else
        puts missing_users_csv_message
      end
      load_test_users if args.test
    end

    private

    def users_file
      DB::CSVTransform.new(file_name: 'import_data/new/users.csv',
                           headers: DB::FileHeader.user).to_a
    end

    def load_test_users
      User.create! [
        {
          nickname: 'admin',
          email: 'admin@example.com',
          password: 'password',
          password_confirmation: 'password',
          role: 'admin'
        },
        {
          nickname: 'user',
          email: 'user@example.com',
          password: 'password',
          password_confirmation: 'password',
          role: 'user'
        }
      ]
    end

    def missing_users_csv_message
      'Warning: users.csv is missing - ' \
      "only test users 'admin' and 'user' can be imported."
    end
  end
end
