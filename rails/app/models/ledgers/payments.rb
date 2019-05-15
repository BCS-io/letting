#####
#
# Payments
#
# Class for handling the collection of payments
#
# to_a - converting to an array
# sum  - summing over the array
#
#####
#
class Payments
  attr_reader :payments

  def initialize payments
    @payments = payments
  end

  def to_a
    payments
  end

  def sum
    payments.map(&:amount).inject(0, &:+)
  end
end
