####
#
# ProductHelper
#
# Used to create blank lines in invoice.
# This ensures cut off line is in the same place,
# independant of number of charges.
####
#
module ProductHelper
  MAX_DISPLAYABLE_PRODUCTS = 8

  def blankers(used_lines:)
    "bottom-#{MAX_DISPLAYABLE_PRODUCTS - used_lines}-line-spacer"
  end
end
