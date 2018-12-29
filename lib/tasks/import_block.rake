require 'csv'

# WARY OF THIS CODE IT DID NOT LOOK LIKE IT WAS WORKING

desc 'Import properties data from CSV file'
task import_block: :environment do
  puts 'Start Import'

  contents = CSV.open 'import_data/properties.csv',
                      headers: true,
                      header_converters: :symbol,
                      converters: ->(field) { field ? field.strip : nil }

  puts 'open file'
  contents.first(33).each do |row|
    block = Block.where(name: row[:housename]).first_or_initialize

    block.assign_attributes name: row[:housename], client_id: row[:clientid]
    # NO not new!!!!!

    unless block.save
      puts "Block Name: #{row[:name]} -  #{block.errors.full_messages}"
    end
  end
end
