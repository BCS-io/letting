require 'csv'
####
# Import Sheet
#
# These are the texts used in the invoices
#
####
namespace :db do
  namespace :import do

    filename = 'import_data/new/sheet.csv'

    desc 'Import invoice text from CSV file'
    task :sheet do
      if File.exist?(filename)
        CSV.foreach(filename, headers: true) do |row|
          begin
            Sheet.create!(row.to_hash)
          rescue
            p 'Sheet Create failed (see hash below):', row.to_hash
          end
        end
      else
        puts "Sheet not found: #{filename}"
      end
    end
  end
end
