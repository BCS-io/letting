###
# CycleDecorator
#
# Adds display logic to the cycle business object.
#
# rubocop: disable Metrics/MethodLength
##
#
class CycleDecorator
  def self.for_select
    {
      'Half Year' => Cycle.where(due_ons_count: 2)
                          .order(order: :asc)
                          .map { |cycle| [select_name(cycle), cycle.id] },
      'Quarterly' => Cycle.where(due_ons_count: 4)
                          .order(order: :asc)
                          .map { |cycle| [select_name(cycle), cycle.id] },
      'Year' => Cycle.where(due_ons_count: 1)
                          .order(order: :asc)
                          .map { |cycle| [select_name(cycle), cycle.id] },
      'Frequent' => Cycle.where(due_ons_count: 5..12)
                          .order(order: :asc)
                          .map { |cycle| [select_name(cycle), cycle.id] }
    }
  end

  def self.select_name cycle
    cycle.name.to_s
  end
end
