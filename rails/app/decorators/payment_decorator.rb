require_relative '../../lib/modules/method_missing'
####
#
# PaymentDecorator
#
# Adds behaviour to the payment object
#
# Used when the payment has need for behaviour outside of the core
# of the model. Specifically for display information.
#
# The main issue is with credit signs. The accounts system maintains negative
# credits. However, the users don't want to think about signs - they want to
# enter data. The decorator changes the sign when displaying data and we change
# it back before saving it.
#
# Sign changing methods
# credits_decorated  - negative to positive.
# initializer        - positive to negative.
#
#
####
#
class PaymentDecorator
  include MethodMissing
  extend ActiveModel::Callbacks
  include ActiveModel::Validations
  include ActiveModel::Validations::Callbacks
  include DateHelper
  include NumberFormattingHelper

  def payment
    @source
  end

  def initialize payment
    @source = payment
  end

  def human_ref
    return '-' unless payment.account

    payment.account.property.human_ref
  end

  # booked_at_dec
  # decorates booked_at with date
  #
  # booked_at => booked_at dec as booked_at used by form to get raw date data.
  #
  def booked_at_dec
    return nil unless payment.booked_at

    format_date payment.booked_at
  end

  def amount
    to_decimal payment.amount
  end

  def credits_decorated
    payment.credits.map do |credit|
      CreditDecorator.new credit
    end.sort_by(&:charge_type)
  end

  def property_decorator
    PropertyDecorator.new payment.account.property
  end

  def last_amount
    return '-' if payment_last_created_at == :no_last_payment

    number_to_currency payment_last_created_at.amount
  end

  def last_human_ref
    return '-' if payment_last_created_at == :no_last_payment

    payment_last_created_at.account.property.human_ref
  end

  def todays_takings
    number_to_currency Payment.created_on.sum(&:amount)
  end

  private

  def payment_last_created_at
    Payment.includes(account: [:property]).last_created_at
  end
end
