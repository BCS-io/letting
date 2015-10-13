require_relative '../../lib/modules/method_missing'

###
#
# AccountDebitDecorator
#
# Adds display logic to the debit business object.
#
##
#
class AccountDebitDecorator
  include MethodMissing
  include DateHelper
  include NumberFormattingHelper

  attr_accessor :running_balance

  def debit
    @source
  end

  def initialize debit
    @source = debit
  end

  delegate :charge_type, to: :debit

  def date
    format_short_date debit.at_time
  end

  def description
    return ChargeTypes::ARREARS \
      if debit.period.first == DateDefaults::MIN.to_date

    "#{format_short_date debit.period.first} to "\
    "#{format_short_date debit.period.last}"
  end

  def due
    to_decimal debit.amount
  end

  def payment
    ''
  end

  def balance
    debit.amount
  end
end
