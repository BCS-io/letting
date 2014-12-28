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
#
class InvoiceMaker
  attr_reader :comments, :property, :invoice_date, :snapshot
  def initialize(property:, invoice_date: Time.zone.today, comments:, snapshot:)
    @property = property
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
               property: property.invoice,
               snapshot: snapshot,
               comments: comments
    invoice.deliver = snapshot.debits? ? :mail : :retain
    invoice
  end
end
