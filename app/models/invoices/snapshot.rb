###
# Snapshot
#
# Link between the invoices, up to 2, and the debits which the
# invoices are responsible. The idea is to only delete the
# debits if both invoices are deleted.
#
# http://stackoverflow.com/questions/6301054/check-all-associations-before-destroy-in-rails
# http://stackoverflow.com/questions/4054112/how-do-i-prevent-deletion-of-parent-if-it-has-child-records
#
###
#
class Snapshot < ActiveRecord::Base
  belongs_to :account, inverse_of: :snapshots
  has_many :invoices, dependent: :destroy, inverse_of: :snapshot
  has_many :debits, dependent: :destroy, inverse_of: :snapshot
  validates :debits, presence: true

  def period
    (period_first..period_last)
  end

  def period=(range)
    self.period_first = range.first
    self.period_last  = range.last
  end

  def debited(debits:)
    self.debits = debits
  end

  def debits?
    debits.any?
  end

  # Plan A - Want to be able to destroy an invoice and not destroy
  #   snapshot if it has another invoice already. (doesn't work)
  # Plan B - test if I should delete debits transaction when deleting invoice
  #   (Working)
  def only_one_invoice?
    invoices.size <= 1
  end

  def self.match(account:, period:)
    where account: account, period_first: period.first, period_last: period.last
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
    debits.map do |debit|
      Product.new debit.to_debitable
    end
  end
end
