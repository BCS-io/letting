###
# ChargeDecorator
#
# Adds display logic to the charge business object.
##
#
class ChargeDecorator
  include MethodMissing
  def charge
    @source
  end

  def initialize charge
    @source = charge
  end

  def charged_in
    charge.charged_in.capitalize
  end

  # If payments happen without requiring an invoice reminder.
  #
  #
  def payment
    charge.payment_type.capitalize
  end

  # If the charge is active or dormant
  # Active charges are generating new debts, dormant charges do not.
  #
  def activity
    charge.activity.capitalize
  end

  # Charges that are dormant should appear different from active charges.
  # This changes the style class for dormant charges.
  #
  def emphasis
    charge.dormant? ? 'deemphasized' : ''
  end
end
