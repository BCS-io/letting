#
# MakeProducts
# Creates collection of Products required for invoices
#   - first product is arrears if in arrears
#
# - snapshot uses it to initialize products in invoice
#
class MakeProducts
  attr_reader :account, :color, :debits, :arrears_date
  def initialize(account:, debits:, arrears_date:, color: :blue)
    @account = account
    @arrears_date = arrears_date
    @debits = debits
    @color = color
  end

  def products
    @products ||= make_products
  end

  def state
    return :forget if debits.empty?
    return :retain if settled
    return :mail if :red == color

    invoice_required? ? :mail : :retain
  end

  private

  def make_products
    products = product_arrears + debits_to_products.sort
    products = apply_balance_to_each totalables: products
    products
  end

  def product_arrears
    product_arrears = Product.arrears(account: account, date_due: arrears_date)
    product_arrears.amount.nonzero? ? [product_arrears] : []
  end

  def debits_to_products
    debits.map { |debit| Product.new debit.to_debitable }
  end

  def apply_balance_to_each(totalables:)
    sum = 0
    totalables.map do |totalable|
      totalable.balance = sum += totalable.amount
      totalable
    end
  end

  def invoice_required?
    debits_to_products.to_a.count { |debit| !debit.automatic? }.nonzero?
  end

  def settled
    final_balance <= 0
  end

  def final_balance
    return 0 if products.empty?

    products.last.balance
  end
end
