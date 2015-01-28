require_relative '../import_base'
require_relative 'balance_row'

module DB
  ####
  #
  # ImportBalance
  #
  # Creates balance debits from row file data.
  #
  ####
  #
  class ImportBalance < ImportBase
    def initialize contents, range
      super Property, contents, range
    end

    def row= row
      @row = BalanceRow.new(row)
    end

    def model_prepared
      @model_to_save = find_model!(Property).first
      @model_to_assign = model_to_save.account.debits.build
    end

    def find_model model_class
      model_class.where human_ref: row.human_ref
    end

    def model_assignment
      model_to_assign.attributes = row.attributes
    end

    def filtered?
      return true if row.amount == 0
      false
    end
  end
end
