require_relative '../import_base'
require_relative 'credit_row'

module DB
  ####
  #
  # ImportPayment
  #
  # Creates payments and builds associated credits from row file data.
  #
  # ImportPayment consumes account information, acc_items.csv, and
  # produces database records.
  #
  # Account process begins with ImportAccount, which contains both
  # opening balances, credits and debits, and this filters the row
  # into their bookkeeping taxonomy and feeds it to the appropriate
  # objects. ImportPayment is responsible for credits and will
  # create a payment and a credit from a row of file data.
  #
  ####
  #
  class ImportPayment < ImportBase
    def initialize contents, range
      super Payment, contents, range
    end

    def row= row
      @row = CreditRow.new(row)
    end

    def model_prepared
      @model_imported = Payment.where(account_id: row.account_id,
                                      booked_at: row.at_time)
                               .first_or_initialize
      fail DB::NotIdempotent, import_not_idempotent_msg, caller \
        unless model_imported.new_record?
    end

    def model_assignment
      @model_imported.attributes = row.payment_attributes
      model_assignment_credits
    end

    def model_assignment_credits
      model_imported.credits.build account_id: row.account_id,
                                   charge_id: row.charge_id,
                                   at_time: row.at_time,
                                   amount: row.amount
    end

    private

    def import_not_idempotent_msg
      "#{row.human_ref}: Import Process for #{self.class} is not idempotent." \
      ' You need to delete Payment and credits before running this task again.'
    end
  end
end
