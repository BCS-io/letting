require 'csv'
####
# Import InvoiceText
#
# These are the texts used in the invoices
#
####
namespace :db do
  namespace :import do
    filename = 'import_data/new/invoice_texts.csv'
    desc 'Import invoice text from CSV file'
    task :invoice_texts do
      if File.exist?(filename)
        CSV.foreach(filename, headers: true) do |row|
          begin
            InvoiceText.create!(row.to_hash)
          rescue StandardError
            p 'InvoiceText Create failed (see hash below):', row.to_hash
          end
        end
      else
        puts "InvoiceText not found: #{filename}"
      end
    end
  end
end
