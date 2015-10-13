require_relative '../import_base'
require_relative 'account_row'
require_relative 'import_balance'
require_relative 'import_debit'
require_relative 'import_payment'

module DB
  ####
  #
  # ImportAccount
  #
  # Wraps around an account item - which is read in from the imported
  # legacy file acc_items (account items). ImportBase is responsible
  # for the generic calls and ImportAccount uses Charge, ImportDebit and
  # ImportPayment to wrap up the data.
  #
  # Charge is called when a new (mostly) debit is seen for the first time.
  # Debit is called when the account is to be debited by a charge.
  # Credit is called when the account is to be credited by a charge
  #
  ####
  #
  class ImportAccount < ImportBase
    def initialize contents, range
      super Property, contents, range
    end

    SPECIALIZED_CLASSES = {
      'balance' => ImportBalance,
      'debit' => ImportDebit,
      'credit' => ImportPayment
    }

    def row= row
      @row = AccountRow.new(row)
    end

    def import_row specialized_row = row
      SPECIALIZED_CLASSES[specialized_row.type]
        .import [specialized_row], range: range
    end

    def filtered?
      range.exclude? row.human_ref
    end
  end
end
