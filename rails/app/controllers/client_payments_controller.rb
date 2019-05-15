####
#
# ClientPaymentsController
#
####
#
class ClientPaymentsController < ApplicationController
  layout 'print_layout'

  def show
    @client_payment = ClientPayment.query client_id: params[:id]
    @client_payment.details year: params[:year].to_i, month: params[:month].to_i
  end
end
