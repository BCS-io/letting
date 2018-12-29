####
#
# Settlement
#
# Settlement allows the ledgers system to pays debits and spends credits.
#
# How does it fit into ledgers ?
#
# Payments create credits and the invoicing, through charges, debits.
# However they only have an affect once a debit is paid off or a credit
# is spent. This is the role of settlements which bridges credits and debits.
#
# In detail
#
# Debits and Credits are created, but they cannot be paid or spent until
# a settlement is generated. Settlements link a credit to a debit.
#
# If a charge_id has an outstanding debit and it receives a credit - a
# settlement is applied to the debit - the smallest of the amounts of debits
# or credits. Visa versa for unspent credit receiving a debit.
#
# When a credit has been spent or a debit paid it is ignored by the
# settlement system.
#
# Settlements is the solution to advance payments.
#
####
#
class Settlement < ActiveRecord::Base
  belongs_to :credit
  belongs_to :debit

  validates :credit, :debit, :amount, presence: true

  # resolving settlement of credits with debits - and visa versa.
  # The amount of the settlement depends on the value(s) of
  # unpaid credit or outstanding debit.
  #
  # settle -  currency amount that has not been offset against.
  # offsets - unspent offsets for this charge - if a debit is offset
  #           by credits and credits by debits.
  #
  def self.resolve settle, offsets
    offsets.each do |offsetable|
      settle -= pay = [settle, offsetable.outstanding].min
      break if pay.round(2).zero?

      yield offsetable, pay
    end
  end
end
