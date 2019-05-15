
# AccountBalanceDecorator
#
# A wrapper around the balance for an account - the balance is also the amount.
# The amount is required to so that it behaves like a credit_decorator and
# debit_decorator
#
#
class AccountBalanceDecorator
  include DateHelper

  attr_accessor :running_balance
  attr_reader :at_time

  def initialize running_balance, date
    @running_balance = running_balance
    @at_time = date
  end

  def amount
    @running_balance
  end

  def amount= amount
    @running_balance = amount
  end

  def charge_type
    'Balance carried forward'
  end

  def description
    ''
  end

  def date
    format_short_date at_time
  end

  def due
    ''
  end

  def payment
    ''
  end

  def balance
    amount
  end
end
