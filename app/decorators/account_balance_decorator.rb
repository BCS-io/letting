
# AccountBalanceDecorator
#
# A wrapper around the balance for an account - the balance is also the amount.
# The amount is required to so that it behaves like a credit_decorator and
# debit_decorator
#
# rubocop: disable Style/TrivialAccessors
#
class AccountBalanceDecorator
  include ActionView::Helpers::NumberHelper

  attr_accessor :running_balance
  attr_reader :on_date

  def initialize running_balance, date
    @running_balance = running_balance
    @on_date = date
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
    I18n.l on_date, format: :short
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
