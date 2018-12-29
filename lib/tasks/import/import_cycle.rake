require 'csv'

####
# Import Cycle
#
# Key value table: id, Cycle Name
#
# 1 Mar/Sep
# 2 Jun/Dec
# 3 Mar/Jun/Sep/Dec
# 4 Apr/July/Oct/Jan
# see definitive values in table cycles / file cycle.csv
#
####
namespace :db do
  namespace :import do
    filename = 'import_data/new/cycle.csv'

    desc 'Import cycles from CSV file'
    task :cycle do
      puts "Cycle import: missing #{filename}" \
        unless File.exist?(filename)

      CSV.foreach(filename, headers: true) do |row|
        begin
          Cycle.create!(row.to_hash) unless comment(row)
        rescue
          p 'Cycle Create failed (see hash below):', row.to_hash
        end
      end
      Cycle.all.each { |cycle| Cycle.reset_counters(cycle.id, :due_ons) }
    end

    def comment row
      row['id'].first == '#'
    end
  end
end
