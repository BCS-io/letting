# FirstRunMaker
#
# Makes invoices given invoicing, comments and date arguments.
#
# FirstRunMaker takes invoicing information and other associated information
# and creates invoices.
#
# Run requires the invoices and makes a call to objects that create invoices
# for it. The first run is a special case and is responsible for creating
# invoices from user supplied arguments(account_range and time period) as well
# as invoice_date and comments.
#
class InvoicesMaker
  attr_reader :comments, :invoice_date, :invoicing

  def initialize invoicing:,
                 invoice_date: Time.zone.today,
                 comments: []
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
    InvoiceMaker.new(account: account,
                     period: invoicing.period,
                     invoice_date: invoice_date,
                     comments: comments,
                     snapshot: snapshot_maker(account),
                     products_maker: products_maker(account))
      .compose
  end

  def snapshot_maker(account)
    SnapshotMaker.new(account: account, debit_period: invoicing.period)
      .invoice
  end

  def products_maker account
    ProductsMaker.new(invoice_date: invoice_date,
                      arrears: account.balance(to_date: invoice_date),
                      snapshot: snapshot_maker(account))
  end
end
