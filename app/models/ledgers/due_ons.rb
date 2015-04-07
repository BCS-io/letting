#####
#
# DueOns
#
# Collection of Dates on which a charge becomes due, billable.
#
# Charges, are queried to see if they are billable within a range of dates. The
# query is passed through cycle onto the DueOns which answer the query
# by quizzing the individual due ons.
#
# The DueOns hold a collection of DueOn - each one has a date that a charge
# becomes due - the dueons, plural, when queried search the dueon, singular to
# find any matching dueon.
#
# Two types of DueOn:
#   OnDate    Day 1-31, Month 1-12
#   PerMonth  Day 1-31, Month -1   (DueOn::PerDate)
#
# If a charge happens on a few dates in the year you use a number of OnDates
# If a charge occurs on each month then you use a PerDate. To create PerMonth
# DueOns we pass a dueon with a Day 1-31 and Month -1 (DueOn::PerDate) via the
# default in a hidden field.
#
# As long as this is different from the current due on we delete
# all the other DueOns in the collection (including the PerMonth DueOn)
# and replace it with 12 onDate DueOns, one for each month.
#
# Persisting DueOns
#
# OnDate DueOns are persisted without modification to the db as
# due_ons row with Day and Month reference id.
# PerMonth DueOns are converted from a single DueOn in memory to 12 dueons on
# the database - this allows the OnDate and PerMonth due_ons to behave the same
# We test for a day and month match.
#
####
#
module DueOns
  extend ActiveSupport::Concern
  included do
    has_many :due_ons, -> { order(:created_at) },
             inverse_of: :cycle,
             dependent: :destroy do
      #
      # between billing_period - MatchedDueOns covering the billing_period
      # billing_period - range of dates over which we ask the due_on
      #                  'do you cover?'
      #
      # returns MatchedDueOn - pair comprising of due date and shown date
      #                        of that due_on - the year added to the
      #                        due on day and month.
      #
      def between billing_period
        map { |due_on| due_on.between billing_period }.flatten.sort
      end

      def prepare(type:)
        @type = type
        (size...find_max_size).each { build }
      end

      def clear_up_form
        each(&:clear_up_form)
      end

      def empty?
        self.all?(&:empty?)
      end

      def day_of_month(day:)
        (0...MAX_DUE_ONS).each_with_index do |item, index|
          self[item].day = day
          self[item].month = index + 1
        end
      end

      def to_s
        'due_ons: ' + map(&:to_s).join(', ')
      end

      private

      def monthly?
        @type == 'monthly'
      end

      def find_max_size
        monthly? ? MAX_DUE_ONS : MAX_DISPLAYED_DUE_ONS
      end
    end

    validate :due_ons_size

    def due_ons_size
      errors.add :due_ons, 'Too many due_ons' \
        if persitable_due_ons.size > MAX_DUE_ONS
    end

    def persitable_due_ons
      due_ons.reject(&:marked_for_destruction?)
    end
  end
  MAX_DISPLAYED_DUE_ONS = 4
  MAX_DUE_ONS = 12
end
