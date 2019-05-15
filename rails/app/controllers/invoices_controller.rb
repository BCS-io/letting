####
#
# Invoices Controller
#
# Controller for printing invoices.
#
# Front page is page 1 used by all invoices
# Ground Rents also have page 2, back page, for legal advice
#
####
#
class InvoicesController < ApplicationController
  layout 'view_layout'

  def show
    @invoice = Invoice.find params[:id]
  end
end
