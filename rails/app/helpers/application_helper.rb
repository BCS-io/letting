####
#
# ApplicationHelper
#
# Shared helper methods
#
####
#
module ApplicationHelper
  def format_empty_string_as_dash a_string
    a_string.presence || '-'
  end

  def payment_types
    Charge.payment_types.keys.map { |type| [type.humanize, type] }
  end
end
