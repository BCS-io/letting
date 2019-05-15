####
#
# PriceBoundValidator
#
# Validates that the amount is valid currency.
# Rails built in numericality handles range but allows zero.
# Wanted validated range AND zero have zero invalidated.
#
# Usage
#
# class Balance
#   validates :amount, price_bound: true
# end
#
# Params are passed to classes as strings. However, by the time they
# are validated they have been parsed and the value is type coerced.
# 'blah' is_a? String
# 100.99 is_a? Float
#
# Further Reading http://api.rubyonrails.org/v4.1.1/classes/ActiveModel/Validator.html
#
####
#
class PriceBoundValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value &&
              (value.is_a? Numeric) &&
              (value.nonzero? && value > -100_000 && value < 100_000)

    record.errors.add attribute, error_message(value)
  end

  def error_message value
    "must be none zero amount between -£100,000 and £100,000. Now: #{value}"
  end
end
