#######
#
# PaymentIndexDecorator
#
# Adds display logic to payment business object.
#
#
class PaymentIndexDecorator
  include MethodMissing
  extend ActiveModel::Callbacks
  include ActiveModel::Validations
  include ActiveModel::Validations::Callbacks
  include DateHelper

  def payment
    @source
  end

  def initialize payment
    @source = payment
  end

  def property_ref
    payment.account.property.human_ref
  end

  def full_name
    payment.account.property.occupiers
  end

  def charge; end

  def booked_at
    format_date payment.booked_at
  end

  def booked_on
    return '' unless payment
    format_short_date payment.booked_at.to_date
  end

  def amount
    number_to_currency payment.amount
  end

  def balance
    number_to_currency \
      payment.account.balance to_time: StringDate.new(booked_at).to_date
  end
end
