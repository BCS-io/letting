require_relative '../../modules/method_missing'
require_relative '../charge_code'
require_relative '../payment_type'
require_relative '../errors'
require_relative 'legacy_charged_in_fields'

module DB
  #####
  #
  # ChargeRow
  #
  # Provides a cleaner interface to the charge field data.
  #
  # The charge import process takes rows of acc_info.csv and creates database
  # rows in the charges table. ImportCharge initializes this object and asks
  # for charge data from it. This object is providing a smoother interface
  # for the process - a layer of indirection between CSV and ImportCharge.
  #
  # rubocop: disable Metrics/ClassLength
  #
  #####
  #
  class ChargeRow
    include MethodMissing
    include ChargedInDefaults

    def row
      @source
    end

    def initialize row
      @source = row
    end

    def human_ref
      row[:human_ref].to_i
    end

    def charge_type
      charge = ChargeCode.to_string charge_code
      fail ChargeCodeUnknown, charge_code_message, caller unless charge
      charge
    end

    def charged_in
      LegacyChargedInFields.new(charged_in_code: charged_in_code,
                                charge_type: charge_type).modern_id
    rescue KeyError
      raise ChargedInCodeUnknown, charged_in_code_message, caller
    end

    def cycle_id
      CycleMatcher.new(charged_in: charged_in,
                       due_on_importables: day_months).id
    rescue CycleUnknown
      warn "Property #{human_ref} charge row does not match a cycle" \
        " (For legacy charge_type: '#{charge_code}') "
    end

    def amount
      row[:amount].to_f
    end

    # Provides a way of cycle_matcher to access all the dates
    # that the charge are invoiced - allowing a cycle matching.
    def day_months
      return create_monthly_dates day(1) if monthly?
      return mid_term_day_months if charged_in_code == LEGACY_MID_TERM
      day_months = []
      1.upto(maximum_dates) do |index|
        break if empty_due_on? month: month(index), day: day(index)
        day_months << DueOnImportable.new(month(index), day(index))
      end
      day_months
    end

    def activity
      amount.zero? ? 'dormant' : 'active'
    end

    def attributes
      {
        charge_type: charge_type,
        cycle_id: cycle_id,
        amount: amount,
        payment_type: payment_type,
        activity: activity,
      }
    end

    def to_s
      "charge_type: #{charge_type}, " \
      "Cycle ID: #{cycle_id}, " \
      "amount: #{amount}, " \
      "activity: #{activity}"
    end

    private

    def payment_type
      PaymentType.to_symbol row[:payment_type].to_sym
    end

    # cycle_matcher requires charge_code as 'M' (month) is a special case
    def monthly?
      charge_code == LEGACY_MID_TERM
    end

    def create_monthly_dates day_of_the_month
      (1..12).each.map { |month| DueOnImportable.new(month, day_of_the_month) }
    end

    # Legacy data defined charged_in Mid-Term to override the meaning of
    # due-dates. The due dates then became the billing period range.
    # This returns the meaning of the due_dates to be the same for mid-term
    # as any other charge. (DueDate is the date which a charge becomes due)
    def mid_term_day_months
      [DueOnImportable.new(3, 25, 6, 24), DueOnImportable.new(9, 29, 12, 25)]
    end

    def maximum_dates
      max_dates = ChargeCode.day_month_pairs charge_code
      fail ChargeCodeUnknown, max_dates_message, caller unless max_dates
      max_dates
    end

    def charge_code
      row[:charge_type]
    end

    def day number
      row[:"day_#{number}"].to_i
    end

    def month number
      row[:"month_#{number}"].to_i
    end

    # most due_ons use empty day month pairing of (0,0)
    # a few, e.g. 7022, use (0,-1)
    def empty_due_on?(month:, day:)
      day.zero? && month.zero? || day.zero? && month == -1
    end

    def charged_in_code
      row[:charged_in]
    end

    def charge_code_message
      "Property #{human_ref}: Charge code #{charge_code} is unknown."
    end

    def max_dates_message
      "Property #{human_ref}: Charge code #{charge_code} " \
      'can not be converted into maximum dates per year.'
    end

    def charged_in_code_message
      "Property #{human_ref}: charged in code #{charged_in_code} is unknown."
    end
  end
end
