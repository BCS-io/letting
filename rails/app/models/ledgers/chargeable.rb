####
#
# Chargeable
#
#  Holds information to turn a charge into a debit
#
#  Invoicing needs to generate debits from charges.
#  It calls on account for due charges and in turn charge
#  generates a Chargeable describing a charge that is due
#  in the queried date range.
#
#  Hashes use symbols as hash keys - faster and saves memory.
#  http://stackoverflow.com/questions/8189416/why-use-symbols-as-hash-keys-in-ruby
#
####
#
class Chargeable
  include Equalizer.new(:account_id, :charge_id, :at_time, :amount)
  attr_reader :account_id, :charge_id, :at_time, :period, :amount

  def self.from_charge(account_id:, charge_id:, at_time:, period:, amount:)
    new account_id: account_id,
        charge_id:  charge_id,
        at_time:    at_time,
        period:     period,
        amount:     amount
  end

  # instance_values is a rails object that returns instances
  # as hashes with keys as named strings .
  #
  def to_hash **overrides
    instance_values.symbolize_keys.merge overrides
  end

  private

  def initialize(account_id:, charge_id:, at_time:, period:, amount:)
    @account_id = account_id
    @charge_id  = charge_id
    @at_time    = at_time
    @period     = period
    @amount     = amount
  end
end
