###
# ProductsMaker
#
# Assembles products from arrears and from the invoiceable debits.
# Calculates products, total_arrears and earliest date for a product.
#
# Products, basically, an account item for the invoice.
#
# @snapshot - the debits created during the invoice period.
#
# @arrears - the amount the account is in arrears
#
# @invoice_date - the date the invoice is dated with. Used by the arrears
#                 product item.
#
# rubocop: disable Style/MultilineTernaryOperator
###
#
class ProductsMaker
  attr_reader :account, :invoice_date, :snapshot
  def initialize(account:, snapshot:, invoice_date:)
    @account = account
    @snapshot = snapshot
    @invoice_date = invoice_date
  end

  # Returns the information required for an invoice
  # products - are the account items of the invoice
  #
  def invoice(*)
    products invoice_date: invoice_date
  end

  # If we any debits are due for this invoice.
  #
  def debits?
    product_debits.present?
  end

  def products(invoice_date:)
    @products ||= product_arrears(invoice_date: invoice_date) + product_debits
  end

  private

  def product_arrears(invoice_date:)
    product_arrears = Product.arrears(account: account, date_due: invoice_date)
    product_arrears.amount.nonzero? ? [product_arrears] : []
  end

  def product_debits
    snapshot.debits.map do |debit|
      Product.new debit.to_debitable
    end
  end
end
