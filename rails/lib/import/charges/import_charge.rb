require_relative '../import_base'
require_relative 'charge_values'
require_relative 'charge_row'

module DB
  ####
  #
  # ImportCharge
  #
  # Load, assigns and saves Charge model objects into the database
  #
  # ImportCharge is called as part of the import.rake task. It reads in a
  # charge.csv file (called acc_info.csv) and creates the charge objects and
  # saves them to charges and due_ons tables.
  #
  # ImportCharge has model_prepared and model_assignment called
  # by ImportBase as part of its import_loop. The private code handles
  # converting the charge.csv into charges (the actual amount) and due_ons
  # (the date when the charge is due).
  #
  # ChargeRow - wrap up the ruby csv row and converts the raw values into
  #             values and identifiers which the program uses.
  ####
  #
  class ImportCharge < ImportBase
    MONTHS_IN_YEAR = 12

    def initialize contents, range
      super Charge, contents, range
    end

    def row= row
      @row = ChargeRow.new(row)
    end

    def model_prepared
      @model_parent = find_model!(Property).first
      @model_imported =
        ChargesMatcher
        .new(model_parent.account.charges)
        .first_or_initialize row.charge_type
      model_parent.prepare_for_form
    end

    def find_model model_class
      model_class.where human_ref: row.human_ref
    end

    # true filters
    # false allows
    #
    def filtered?
      return true if range.exclude? row.human_ref

      false
    end

    def model_assignment
      model_imported.assign_attributes row.attributes
    end
  end
end
