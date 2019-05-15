#
# Controller for viewing Account Arrears
#
#
class ArrearsController < ApplicationController
  def index
    params[:arrears_search] ||= '100.00'
    @records = AccountDetails.balance_all(greater_than: params[:arrears_search])
  end
end
