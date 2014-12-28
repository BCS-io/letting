# InvoicesMaker
#
# Makes invoices given invoicing, comments and date arguments.
#
# InvoicesMaker takes invoicing information and other associated information
# and creates invoices.
#
# Run requires the invoices and makes a call to objects that create invoices
# for it. This is responsible for creating invoices from user supplied
# arguments(account_range and time period) as well as invoice_date and comments.
#
class InvoicesMaker
  attr_reader :comments, :invoice_date, :invoicing

  def initialize invoicing:, invoice_date: Time.zone.today, comments: []
    @invoicing = invoicing
    @invoice_date = invoice_date
    @comments = comments
  end

  def invoices
    @invoices ||= invoicing
                  .accounts
                  .map { |account| invoice_maker(account: account) }
  end

  def to_s
    run.each(&:to_s)
  end

  private

  def invoice_maker account: account
    InvoiceMaker.new(property: account.property,
                     invoice_date: invoice_date,
                     comments: comments,
                     snapshot: snapshot_maker(account))
      .compose
  end

  def snapshot_maker(account)
    snapshot = Snapshot.match(account: account, period: invoicing.period).first
    snapshot = SnapshotMaker.new(account: account,
                                 debit_period: invoicing.period)
               .invoice unless snapshot
    snapshot
  end
end
