require_relative '../../lib/modules/method_missing'

###
#
# AccountDebitDecorator
#
# Adds display logic to the debit business object.
#
# rubocop: disable Style/TrivialAccessors
##
#
class AccountDebitDecorator
  include MethodMissing
  include ActionView::Helpers::NumberHelper

  attr_accessor :running_balance

  def debit
    @source
  end

  def initialize debit
    @source = debit
  end

  delegate :charge_type, to: :debit

  def date
    I18n.l debit.on_date, format: :short
  end

  def description
    "#{I18n.l debit.period.first, format: :short} to "\
    "#{I18n.l debit.period.last, format: :short}"
  end

  def due
    number_with_precision(debit.amount, precision: 2)
  end

  def payment
    ''
  end

  def balance
    debit.amount
  end
end
