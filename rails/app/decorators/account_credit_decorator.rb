require_relative '../../lib/modules/method_missing'

###
#
# AccountCreditDecorator
#
# Adds display logic to the credit business object.
#
##
#
class AccountCreditDecorator
  include MethodMissing
  include DateHelper
  include NumberFormattingHelper

  attr_accessor :running_balance

  def credit
    @source
  end

  def initialize credit
    @source = credit
  end

  delegate :charge_type, to: :credit

  def date
    format_short_date credit.at_time
  end

  def description
    'Payment'
  end

  def due
    ''
  end

  def payment
    to_decimal credit.amount
  end

  def balance
    -credit.amount
  end
end
