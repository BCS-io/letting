require 'csv'
####
# Import InvoiceText Address
#
# addressable_id: 1
#
# These are the texts used in the invoices for F&L Adam's address
#
####
namespace :db do
  namespace :import do
    filename = 'import_data/new/invoice_text_address.csv'

    desc "Import invoice text F&L Adam's address from CSV file"
    task :invoice_text_address do
      if File.exist?(filename)
        CSV.foreach(filename, headers: true) do |row|
          begin
            Address.create!(row.to_hash)
          rescue StandardError
            p 'InvoiceText Address Create failed (see hash below):', row.to_hash
          end
        end
      else
        puts "InvoiceText Address not found: #{filename}"
      end
    end
  end
end
