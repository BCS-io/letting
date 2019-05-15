require 'csv'
####
# Import InvoiceText Guide
#
# These are the texts used in the invoices for F&L Adam's guides
#
####
namespace :db do
  namespace :import do
    filename = 'import_data/new/invoice_text_guide.csv'

    desc "Import invoice text F&L Adam's guides from CSV file"
    task :invoice_text_guide do
      if File.exist?(filename)
        CSV.foreach(filename, headers: true) do |row|
          begin
            Guide.create! row.to_hash
          rescue StandardError => e
            p 'InvoiceText Guide Create failed (see hash below):', row.to_hash
            raise e
          end
        end
      else
        puts "InvoiceText Guide not found: #{filename}"
      end
    end
  end
end
