require_relative '../charge_code'

module DB
  ####
  #
  # ChargeValues
  #
  # Wraps up the pairings of charge and periods into
  # a single object
  #
  ####
  #
  class ChargeValues
    attr_reader :charge_code
    attr_reader :max_dates_per_year

    def self.from_code(code)
      new ChargeCode.to_string(code), ChargeCode.day_month_pairs(code)
    end

    def initialize charge_code, max_dates_per_year
      @charge_code = charge_code
      @max_dates_per_year = max_dates_per_year
    end
  end
end
