require_relative '../modules/payment_type_defaults'

module DB
  ####
  #
  # Payment Type
  #
  # Mapping Legacy payment types to modern types
  #
  # Used in importing charges
  #
  ####
  #
  class PaymentType
    include PaymentTypeDefaults
    def self.to_symbol code
      case code
      when :S      then AUTOMATIC
      when :P, :L  then MANUAL
      else         UNKNOWN_PAYMENT_TYPE
      end
    end
  end
end
