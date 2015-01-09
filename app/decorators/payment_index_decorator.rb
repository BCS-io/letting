#######
#
# PaymentIndexDecorator
#
# Adds display logic to payment business object.
#
# rubocop: disable Style/TrivialAccessors
#
class PaymentIndexDecorator
  include MethodMissing
  extend ActiveModel::Callbacks
  include ActiveModel::Validations
  include ActiveModel::Validations::Callbacks
  include ActionView::Helpers::NumberHelper

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

  def charge
  end

  def booked_on
    I18n.l payment.booked_on, format: :human
  end

  def amount
    number_to_currency payment.amount
  end

  def balance
    number_to_currency \
      payment.account.balance to_time: StringDate.new(booked_on).to_date
  end
end
