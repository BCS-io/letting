####
#
# ApplicationNumberFormatting
#
####
#
module NumberFormattingHelper
  def to_decimal amount
    number_with_precision amount, precision: 2, delimiter: ','
  end
end
