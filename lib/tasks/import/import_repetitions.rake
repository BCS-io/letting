require 'csv'

####
# Import Repetitions
#
####
namespace :db do
  namespace :import do
    filename = 'import_data/new/repetitions.csv'

    desc 'Import cycles from CSV file'
    task :repetitions do
      puts "repetitions import: missing #{filename}" \
        unless File.exist?(filename)

      CSV.foreach(filename, headers: true) do |row|
        begin
          Repetitions.create!(row.to_hash) unless comment(row)
        rescue StandardError
          p 'Repetitions Create failed (see hash below):', row.to_hash
        end
      end
    end

    def comment row
      row['id'].first == '#'
    end
  end
end
