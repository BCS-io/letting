# InvoicesMaker
#
# Makes invoices given invoicing, invoice_date and comments.
#
# InvoicesMaker takes invoicing information and other associated information
# and creates invoices for the matching accounts.
#
# Run requires the invoices and makes a call to objects that create invoices
# for it. This is responsible for creating invoices from user supplied
# arguments(account_range and time period) as well as invoice_date and comments.
#
# property     - the property to invoice
# invoice_date - the date which the invoice is dated on
#                affects the date which the arrears balance is created for.
# snapshot     - the state of the accounts at the time
# comments     - information string to be applied to the invoice.
#
class InvoicesMaker
  attr_reader :color, :comments, :invoice_date, :invoicing

  def initialize invoicing:, color:, invoice_date: Time.zone.today, comments: []
    @invoicing = invoicing
    @color = color
    @invoice_date = invoice_date
    @comments = comments
  end

  def invoices
    @invoices ||= invoicing
                  .accounts
                  .map do |account|
                    make_invoice(account: account)
                  end
  end

  private

  def make_invoice(account:)
    (invoice = Invoice.new)
      .prepare property: account.property.invoice,
               color: color,
               snapshot: make_snapshot(account),
               invoice_date: invoice_date,
               comments: comments
    invoice
  end

  # snapshot - the debits created during the invoicing period
  #   finds a snapshot (if any), Otherwise creates a snapshot.
  #
  def make_snapshot(account)
    snapshot = Snapshot.find(account: account, period: invoicing.period)
    return snapshot if snapshot

    SnapshotMaker.new(account: account, debit_period: invoicing.period).invoice
  end
end
