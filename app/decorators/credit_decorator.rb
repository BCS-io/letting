require_relative '../../lib/modules/method_missing'

###
#
# CreditDecorator
#
# Adds display logic to the credit business object.
#
# Used by payment decorator .
#
##
#
class CreditDecorator
  include ActionView::Helpers::NumberHelper
  include MethodMissing
  include NumberFormattingHelper

  def credit
    @source
  end

  def initialize credit
    @source = credit
  end

  def amount
    to_decimal credit.amount
  end

  def owing
    to_decimal charge_debt
  end

  # payment
  # Payment amounts have different behaviour when new and when edited.
  # When new we take the amount owing as the default
  # When editing we take the amount already paid.
  #
  def payment
    if credit.new_record?
      to_decimal_edit charge_debt
    else
      to_decimal_edit credit.amount
    end
  end

  private

  def charge_debt
    Debit.debt_on_charge(charge_id)
  end
end
