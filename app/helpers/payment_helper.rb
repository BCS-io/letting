####
#
# PaymentHelper
#
# Shared helper methods
#
####
#
module PaymentHelper
  def payment_date(date:)
    params[:date] == date.to_s ? 'pair-focus  text-normal' : ''
  end
end
