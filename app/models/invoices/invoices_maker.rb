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
class InvoicesMaker
  attr_reader :comments, :property_range, :period, :invoices, :invoice_date
  def initialize(property_range:,
                 period:,
                 invoice_date: Time.zone.today,
                 comments:)
    @property_range = property_range
    @period = period
    @invoice_date = invoice_date
    @comments = comments
  end

  #
  # compose
  # Make invoices
  #
  def compose
    @invoices = make_invoices accounts: composeable(accounts: property_range)
    self
  end

  private

  def composeable(accounts:)
    Account.between?(accounts).includes(account_includes).select do |account|
      DebitMaker.new(account: account, debit_period: period).mold.make?
    end
  end

  def make_invoices(accounts:)
    accounts.map { |account| make_invoice account: account }
  end

  def make_invoice(account:)
    (invoice = Invoice.new).prepare \
      account: account,
      invoice_date: invoice_date,
      property: account.property.invoice(billing_period: period),
      debits_transaction: DebitMaker.new(account: account, debit_period: period)
                                    .mold.invoice,
      comments: comments
    invoice
  end

  def account_includes
    [[property: property_includes], :credits, :charges, :debits]
  end

  def property_includes
    [:entities, :address,
     client: [:address, :entities],
     agent:  [:address, :entities]]
  end
end