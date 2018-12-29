require_relative '../../modules/method_missing'
require_relative '../charge_code'
require_relative '../errors'
require_relative 'accounting_row'

module DB
  ####
  #
  # BalanceRow
  #
  # Wraps around an imported row of data from the acc_items csv. This is the
  # mapping from acc_items => Ruby hash values
  #
  # Account Items    FileHeader.account
  # PropertyID       human_ref          - No used by humans to ID an account
  # Type             charge_code        - Identifier used in the legacy app.
  # IDate            at_time
  # Description      description
  # Due              debit
  # Paid             credit
  # Balance          balance
  #
  #
  ####
  #
  class BalanceRow
    include MethodMissing
    include AccountingRow

    def row
      @source
    end

    def initialize row
      @source = row
    end

    def human_ref
      row[:human_ref].to_i
    end

    # The attributes used to create the balance object
    #
    def attributes
      {
        charge_id: charge_from_row.id,
        at_time: next_at_time,
        period: period,
        amount: amount
      }
    end

    # Charge determined from row information
    #
    def charge_from_row
      charge account: account(human_ref: human_ref), charge_type: charge_type
    end

    # The next datetime that a charge would become due
    # Allows us to put a balance at the start of a charge period
    #
    # TODO: May-never happen
    # IF I can work out the start of the date range from a given
    # at_time I can wind back a blance_row to the start of the
    # period.
    # Currently, I am finding the balance_row date of charge and finding the
    # first time on or after that when we're charged and making that balance
    # row date. (at_time)
    #
    def next_at_time
      charge_from_row.coming(at_time..at_time + 1.year - 1.day)
                     .first
                     .at_time
                     .beginning_of_day
    end

    # DateTime that a balance is said to have occurred.
    #
    def at_time
      Time.zone.parse(row[:at_time]).beginning_of_day
    end

    # The dates over which the balance is said to have applied.
    #
    def period
      DateDefaults::MIN..at_time.to_date
    end

    # debits are positive amounts that increase an account balance.
    #
    def amount
      row[:debit].to_f
    end

    # Calculate the charge_type from legacy information and guesses
    # of imported information.
    #
    def charge_type
      if row[:charge_code] == 'Bal'
        charge_type = description_to_charge_type
        charge_type = account(human_ref: human_ref).charges.first.charge_type \
          if charge_type.blank?
        charge_type
      else
        charge_code_to_s charge_code: row[:charge_code], human_ref: human_ref
      end
    end

    def message
      "\nProperty #{human_ref} charge_code: #{row[:charge_code]}\n"
    end

    private

    # Calculates a charge_type (string name for a charge) from a description
    #
    def description_to_charge_type
      return ChargeTypes::SERVICE_CHARGE \
        if row[:description].include?('Service') ||
           row[:description].include?('SC')
      return ChargeTypes::GARAGE_GROUND_RENT \
        if row[:description].include? 'Garage'
    end
  end
end
