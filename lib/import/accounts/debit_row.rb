require_relative '../../modules/method_missing'
require_relative '../charge_code'
require_relative '../errors'
require_relative 'accounting_row'

module DB
  ####
  #
  # DebitRow
  #
  # Wraps around an imported row of data.
  #
  # Called during the Importing of accounts information.
  # Debits are passed to ImportDebit and during the imported
  # row is wrapped with this DebitRow. During the importing
  # the data needs to relate to other imported rows, charges
  # in this case, and this is hides this behaviour from the
  # ImportDebit.
  #
  # Errors do not go to logger
  # rubocop: disable Rails/Output
  #
  #
  ####
  #
  class DebitRow
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

    def charge_code
      row[:charge_code]
    end

    def at_time
      # HACK: All legacy data comes in at midnight.
      #       by pushing forward the 'time' balance occurs before any debits.
      row[:at_time].to_datetime + 3.hours
    end

    def period
      period = charge(account: account(human_ref: human_ref),
                      charge_type: charge_type)
               .cycle
               .bill_period(billed_on: at_time.to_date)
      fail PeriodUnknown,
           period_message,
           caller unless period != :missing_due_on
      period
    end

    # debits increase an account balance.
    # debits amounts are positive (+)
    #
    def amount
      debit
    end

    def charge_id
      charge(account: account(human_ref: human_ref),
             charge_type: charge_type).id
    end

    def charge_type
      charge_code_to_s(charge_code: charge_code,
                       human_ref: human_ref)
    end

    def attributes
      {
        charge_id: charge_id,
        at_time: at_time,
        period: period,
        amount: amount,
      }
    end

    def period_message
      "Period Unknown: Property #{human_ref} charge_code: #{charge_code} "\
      "at_time: #{at_time}"
    end

    private

    def debit
      debit = row[:debit].to_f
      if negative_credit?
        puts "Property #{human_ref}: converting negative credit to debit"
        debit = credit * -1
      end
      debit
    end

    def negative_credit?
      credit < 0
    end

    def credit
      row[:credit].to_f
    end
  end
end
