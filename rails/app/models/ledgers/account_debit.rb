####
#
# AccountDebit
#
# Debits due on an account - structure used for display in a view page
#
####
#
class AccountDebit
  include Comparable
  attr_reader :amount, :date_due, :charge_type, :property_refs
  def initialize(date_due:, charge_type:, property_ref:, amount:)
    @date_due = date_due
    @charge_type = charge_type
    @property_refs = Consecutize.new elements: [property_ref]
    @amount = amount
  end

  def key
    [date_due, charge_type]
  end

  def property_refs_to_s
    @property_refs.to_s
  end

  def merge(account_debit)
    @property_refs.merge account_debit.property_refs
  end

  def <=> other
    return nil unless other.is_a?(self.class)

    [date_due, charge_type] <=> [other.date_due, other.charge_type]
  end

  def to_s
    "key: #{key} - value: due: #{date_due}, charge: #{charge_type}, "\
    "refs: #{property_refs_to_s}"
  end
end
