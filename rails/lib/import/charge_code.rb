require_relative '../modules/charge_types'

module DB
  ####
  #
  # ChargeCode
  #
  # One place for mappings of charge code into other values
  #
  # Used in importing charges and account rows.
  #
  # to_string has CyclomaticComplexity of 7 with 6 acceptable.
  # rubocop:disable  Metrics/CyclomaticComplexity
  ####
  #
  class ChargeCode
    include ChargeTypes
    def self.to_string(code)
      case code
      when 'Bal'         then ARREARS
      when 'GGR'         then GARAGE_GROUND_RENT
      when 'GIns'        then GARAGE_INSURANCE
      when 'GR'          then GROUND_RENT
      when 'H', 'M', 'Q' then SERVICE_CHARGE
      when 'Ins'         then INSURANCE
      end
    end

    def self.day_month_pairs code
      case code
      when 'GR', 'GGR', 'GIns', 'Ins', 'Q' then 4
      when 'H' then 2
      when 'M' then 1
      end
    end
  end
end
