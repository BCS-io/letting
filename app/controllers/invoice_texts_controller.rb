##
#
# InvoiceTextsController
#
# Restful actions on the InvoiceText resource
#
# InvoiceTexts are used to create invoices, they hold data needed to produce
# heading, business address, notes and items on invoice and notice of rent due.
# Front page is page 1 used by all invoices Ground Rents also have page 2,
# back page, for legal advice
####
#
class InvoiceTextsController < ApplicationController
  def index
    @invoice_texts = InvoiceText.order(:id)
  end

  def show
    @invoice_text = InvoiceText.find params[:id]
  end

  def edit
    @invoice_text = InvoiceText.find params[:id]
  end

  def update
    @invoice_text = InvoiceText.find params[:id]
    if @invoice_text.update invoice_texts_params
      redirect_to invoice_text_path, flash: { save: updated_message }
    else
      render :edit
    end
  end

  private

  def invoice_texts_params
    params.require(:invoice_text).permit \
      %i[description invoice_name phone vat heading1 heading2 advice1 advice2],
      address_attributes: address_params,
      guides_attributes: guides_params
  end

  def guides_params
    %i[id instruction fillin sample]
  end

  def identity
    'Invoice Texts'
  end
end
