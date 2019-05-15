####
#
# Runs Controller
#
# Controller for printing a run of invoices to the screen.
#
# Show action displays the invoicing run onto the screen. Formatted for
# printing.
#
####
#
class RunsController < ApplicationController
  layout 'view_layout'

  def show
    @run = Run.includes(invoices: [:snapshot]).find params[:id]
  end

  def destroy
    @run = Run.find params[:id]
    @invoicing = @run.invoicing
    cached_message = deleted_message
    @run.destroy
    redirect_to invoicing_path(@invoicing), flash: { delete: cached_message }
  end

  def identity
    "Run #{@run.invoice_date}"
  end
end
