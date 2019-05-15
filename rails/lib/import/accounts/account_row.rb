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
  #
  ####
  #
  class AccountRow
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

    def type
      return 'balance' if balance?
      return 'debit' if debit?
      return 'credit' if credit?

      raise AccountRowTypeUnknown, account_type_unknown_msg
    end

    private

    def balance?
      row[:charge_code] == 'Bal' || row[:description] == 'Balance'
    end

    def credit?
      row[:credit].to_f.nonzero?
    end

    def debit?
      row[:debit].to_f.nonzero? || row[:credit].to_f.negative?
    end

    def account_type_unknown_msg
      "Unknown Row Property:#{human_ref}, charge_code: #{row[:charge_code]}"
    end
  end
end
