####
#
# Invoicing
#
# Creating a batch of invoices to bill customers.
#
# The user searches for property-ids within a date range that will be billed.
# Invoicing controller returns accounts that are to be debited to the invoicing
# object - which then creates the appropriate invoices for these properties.
#
# An invoice is the information required to print an invoice. Made up of
# property related information and the products (services) that are charged
# during the time period of the invoice.
#
class Invoicing < ActiveRecord::Base
  has_many :invoices

  def generate(account_ids:)
    accounts = Account.find account_ids
    self.property_range = properties_range(accounts)
    accounts.each do |account|
      invoice = invoices.build
      invoice.prepare account: account
      invoice.prepare_products debits: account.make_debits(start_date..end_date)
    end
  end

  def properties_range accounts
    "#{accounts.first.property.human_ref} - #{accounts.last.property.human_ref}"
  end
end
