require_relative '../../lib/modules/method_missing'

###
#
# AccountCreditDecorator
#
# Adds display logic to the credit business object.
#
# rubocop: disable Style/TrivialAccessors
##
#
class AccountCreditDecorator
  include MethodMissing
  include ActionView::Helpers::NumberHelper

  attr_accessor :running_balance

  def credit
    @source
  end

  def initialize credit
    @source = credit
  end

  delegate :charge_type, to: :credit

  def date
    I18n.l credit.on_date, format: :short
  end

  def description
    'Payment'
  end

  def due
    ''
  end

  def payment
    number_with_precision(credit.amount, precision: 2)
  end

  def balance
    -credit.amount
  end
end
