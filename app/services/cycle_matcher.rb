require_relative '../../lib/import/errors'

####
#
# CycleMatcher
#
# Identifies a collection of due_ons as a specific Cycle.
#
# During the import of the legacy acc_info file the import_charge code presents
# ChargeRow with a number of reoccurring dates (day and month that occur every
# year) - these dates are converted into an id that matches a cycle. This
# is the class responsible for the conversion.
#
####
#
class CycleMatcher
  attr_reader :unidentified
  def initialize(charged_in:, due_on_importables:)
    @unidentified = Cycle.new name: 'unknown',
                              charged_in: charged_in
    due_on_importables.each do |due_on_importable|
      @unidentified.due_ons.build day: due_on_importable.day,
                                  month: due_on_importable.month,
                                  show_month: due_on_importable.show_month,
                                  show_day: due_on_importable.show_day
    end
  end

  def id
    return warn 'Cycle table has no records' unless Cycle.any?
    found_structure = find
    raise DB::CycleUnknown unless found_structure
    found_structure.id
  end

  private

  def find
    Cycle.all.find do |cycle|
      cycle == unidentified
    end
  end
end
