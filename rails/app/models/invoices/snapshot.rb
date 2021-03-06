###
# Snapshot
#
# The generation of a set of debts onto a single account.
#
# Link between the many invoices, normally 1 or 2, and the debits which the
# invoices are responsible. The idea is to only delete the debits if both
# invoices are deleted.
#
# http://stackoverflow.com/questions/6301054/check-all-associations-before-destroy-in-rails
# http://stackoverflow.com/questions/4054112/how-do-i-prevent-deletion-of-parent-if-it-has-child-records
#
###
#
class Snapshot < ApplicationRecord
  belongs_to :account, inverse_of: :snapshots
  has_many :invoices, dependent: :destroy, inverse_of: :snapshot
  has_many :debits, dependent: :destroy, inverse_of: :snapshot

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

  def make_products(color:)
    MakeProducts.new(account: account,
                     debits: debits,
                     color: color)
  end

  def first_invoice? invoice
    invoices.first == invoice
  end

  # find
  #
  # fails to match on the first invoicing run.
  # matches on the second and subsequent runs.
  #
  def self.find(account:, period:)
    find_by(account: account, period_first: period.first, period_last: period.last)
  end
end
