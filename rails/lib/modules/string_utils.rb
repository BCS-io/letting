# rubocop: disable Style/DoubleNegation

# StringUtils
#
# Adding methods useful to string but avoiding monkey patching
#
module StringUtils
  extend ActiveSupport::Concern
  module ClassMethods
    # num?
    #
    # Detects if a string can be converted into a number
    #
    # Why am I writing, what would seem, a core function? Because Ruby takes the
    # string '10 Dowton' and converts using to_i to 10. This is not what I
    # desire - and indeed doesn't make much sense.
    #
    def num? str
      !!Integer(str)
    rescue ArgumentError, TypeError
      false
    end
  end
end
