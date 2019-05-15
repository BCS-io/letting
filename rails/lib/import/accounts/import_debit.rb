require_relative '../import_base'
require_relative 'debit_row'

module DB
  ####
  #
  # ImportDebit
  #
  # Creates debits from row file data.
  #
  # ImportDebit consumes account information, acc_items.csv, and produces
  # database records.
  #
  # Importing Accounts (which this is part of) begins with ImportAccount,
  # which contains both opening balances, credits and debits, and this
  # filters the row into their bookkeeping taxonomy and feeds it to the
  # appropriate objects. ImportDebit is responsible for debits and creates a
  # debit for each debit in acc_items.
  #
  ####
  #
  class ImportDebit < ImportBase
    def initialize contents, range
      super Property, contents, range
    end

    def row= row
      @row = DebitRow.new(row)
    end

    def model_prepared
      @model_parent = find_model!(Property).first
      @model_imported = model_parent.account.debits.build
    end

    def find_model model_class
      model_class.where human_ref: row.human_ref
    end

    def model_assignment
      model_imported.attributes = row.attributes
    end
  end
end
