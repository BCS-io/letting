####
#
# Print_Invoices Controller
#
# PrintInvoicesController for printing single invoices.
#
# Show is the same as invoices/show, which puts the invoices to screen.
# This show prints the invoices out.
#
####
#
class PrintInvoicesController < ApplicationController
  layout 'print_layout'

  def show
    @invoice = Invoice.find params[:id]
    render 'invoices/show'
  end
end
