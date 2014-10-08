require_relative '../../modules/method_missing'
require_relative '../charge_code'
require_relative '../errors'
require_relative 'accounting_row'

module DB
  ####
  #
  # AccountRow
  #
  # Wraps around an imported row of data acc_items.
  #
  # Called during the Importing of accounts information.
  # ImportAccount assigns a row to AccountRow
  #
  # AccountRow knows the type responsible for importing the file row
  # - balance row, credit row or debit row. ImportAcccount is responsible
  # for instantiating the appropriate row which is then responsible for the
  # remaining import.
  #
  ####
  #
  class AccountRow
    include MethodMissing
    include AccountingRow

    def initialize row
      @source = row
    end

    def human_ref
      @source[:human_ref].to_i
    end

    def type
      return 'balance' if balance?
      return 'debit' if debit?
      return 'credit' if credit?
      fail AccountRowTypeUnknown, account_type_unknown_msg
    end

    private

    def balance?
      @source[:charge_code] == 'Bal' || @source[:description] == 'Balance'
    end

    def credit?
      @source[:credit].to_f != 0
    end

    def debit?
      @source[:debit].to_f != 0 || @source[:credit].to_f < 0
    end

    def account_type_unknown_msg
      "Unknown Row Property:#{human_ref}, charge_code: #{@source[:charge_code]}"
    end
  end
end
