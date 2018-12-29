#
# MakeProducts
# Creates collection of Products required for invoices
#   - first product is arrears if in arrears
#
# - snapshot uses it to initialize products in invoice
#
class MakeProducts
  attr_reader :account, :color, :debits, :arrears_date
  def initialize(account:, debits:, color: :blue)
    @account = account
    @debits = debits
    @color = color
  end

  def products
    @products ||= make_products
  end

  def state
    return :forget if debits.empty?
    return :retain if settled
    return :mail if color == :red

    invoice_required? ? :mail : :retain
  end

  private

  def make_products
    products = product_arrears + debits_to_products.sort
    products = apply_balance_to_each totalables: products
    products
  end

  def product_arrears
    product_in_arrear = Product.arrears(account: account, date_due: arrears_cut_off)
    product_in_arrear.amount.nonzero? ? [product_in_arrear] : []
  end

  def debits_to_products
    debits.map { |debit| Product.new debit.to_debitable }
  end

  def arrears_cut_off
    return Date.new(1980, 1, 1) if debits_to_products.empty?

    # ledgers/Debit.until < does not behave as I expect so I am removing 1 day here
    debits_to_products.map(&:date_due).min - 1.day
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
