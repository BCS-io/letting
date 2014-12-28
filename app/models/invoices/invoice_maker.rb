####
#
# InvoicesMaker
#
# Class responsible for making invoices within a property and invoicing period.
#
# Invoicing maintains property-ids within a date range that will be billed.
# period. This is passed to invoice maker, this class, which creates the
# invoices.
#
# rubocop: disable  Metrics/MethodLength,  Metrics/LineLength, Metrics/ParameterLists
#
class InvoiceMaker
  attr_reader :comments, :account, :period, :invoice_date, :snapshot, :products_maker
  def initialize(account:,
                 invoice_date: Time.zone.today,
                 comments:,
                 snapshot:)
    @account = account
    @invoice_date = invoice_date
    @comments = comments
    @snapshot = snapshot
  end

  #
  # compose
  # Make invoices
  #
  def compose
    make_invoice
  end

  private

  def make_invoice
    (invoice = Invoice.new)
      .prepare invoice_date: invoice_date,
               property: account.property.invoice,
               snapshot: snapshot,
               comments: comments
    invoice.deliver = snapshot.debits? ? :mail : :retain
    invoice
  end
end
