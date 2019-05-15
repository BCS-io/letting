####
#
# Invoicing Controller
#
# Invoicing for batches of invoices.
#
# TODO: remove the following rubocop errors
# rubocop: disable Metrics/ClassLength, Metrics/MethodLength
#
####
#
class InvoicingsController < ApplicationController
  include InvoicingHelper

  def index
    @invoicings = Invoicing.includes(runs: [:invoices]).page(params[:page]).default.load
  end

  # show lists out each invoice from an invoice run
  #
  def show
    @invoicing = Invoicing.includes(runs: [invoices: [:products]])
                          .find params[:id]
  end

  def new
    @invoicing = Invoicing.new \
      property_range: SpaceOut.process(params[:search_terms]),
      period: get_period_first..get_period_last
    @invoicing.generate if @invoicing.valid_arguments?
    set_session
  end

  # create
  # invoicing_params:
  #   - property_range - property ids to be invoiced
  #   - period:        - the dates over which the invoicing occurs
  # params: invoice_date - the date on the invoice
  #
  # generate - takes the params and makes the associated run. The run comprises
  #            of a number of invoices.
  #
  def create
    set_session_from_params
    @invoicing = Invoicing.new invoicing_params
    @invoicing.period_first = get_period_first
    @invoicing.period_last = get_period_last
    if @invoicing.valid_arguments?
      @invoicing.generate invoice_date: params[:invoice_date],
                          comments: params[:comment]
    end
    if @invoicing.save
      redirect_to invoicing_path(@invoicing), flash: { save: created_message }
    else
      set_session
      render :new
    end
  end

  def edit
    @invoicing = Invoicing.includes(join_tables).find params[:id]
    @invoicing.generate if @invoicing.valid_arguments?
    set_invoice_date date: get_invoice_date
  end

  def update
    set_invoice_date date: params[:invoice_date]
    @invoicing = Invoicing.find params[:id]
    if @invoicing.valid_arguments?
      @invoicing.generate invoice_date: params[:invoice_date],
                          comments: params[:comment]
    end
    if @invoicing.save
      redirect_to invoicing_path(@invoicing), flash: { save: updated_message }
    else
      render :edit
    end
  end

  def destroy
    @invoicing = Invoicing.find params[:id]
    cached_message = deleted_message
    @invoicing.destroy
    redirect_to invoicings_path, flash: { delete: cached_message }
  end

  private

  def set_session_from_params
    set_default_dates !params[:default_dates]
    set_period_first date: params[:period_first] if params[:period_first]
    set_period_last date: params[:period_last] if params[:period_last]
    set_invoice_date date: params[:invoice_date]
  end

  def set_session
    set_default_dates get_default_dates?
    set_period_first date: get_period_first
    set_period_last date: get_period_last
    set_invoice_date date: get_invoice_date
  end

  helper_method :get_default_dates?

  # Are we using the default dates (looking 7 weeks ahead or not?)
  #
  def get_default_dates?
    return session[:invoicings_default_dates] \
      unless session[:invoicings_default_dates].nil?

    session[:invoicings_default_dates] = true
  end

  def set_default_dates(chosen)
    session[:invoicings_default_dates] = params[:default_dates] = chosen
  end

  def get_period_first
    return session[:invoicings_period_first] \
      if session[:invoicings_period_first].present?

    session[:invoicings_period_first] = Time.zone.today.to_s
  end

  def set_period_first(date:)
    session[:invoicings_period_first] = params[:period_first] = date
  end

  def get_period_last
    return session[:invoicings_period_last] \
      if session[:invoicings_period_last].present?

    session[:invoicings_period_last] =
      (Time.zone.today + Invoicing::WEEKS_AHEAD.weeks).to_s
  end

  def set_period_last(date:)
    session[:invoicings_period_last] = params[:period_last] = date
  end

  # Invoice_date is a date that appears on the top of an invoice
  # The value is not used for anything else.
  # invoice_date returns today's date if the session gets set to nil or ""
  #
  def get_invoice_date
    return session[:invoicings_invoice_date] \
      if session[:invoicings_invoice_date].present?

    session[:invoicings_invoice_date] = Time.zone.today
  end

  # All invoice_date
  #
  def set_invoice_date(date:)
    session[:invoicings_invoice_date] = params[:invoice_date] = date
  end

  # invoicing_params
  #  - white listing of user supplied data
  #
  def invoicing_params
    params
      .require(:invoicing)
      .permit %i[property_range period_first period_last]
  end

  # join_tables
  #  - specifies the relationships to be included in the result set
  #
  def join_tables
    { runs: [invoices: [snapshot: [debits: [:charge]]]] }
  end

  def identity
    invoicing = InvoicingIndexDecorator.new @invoicing
    "Invoicing Range #{invoicing.property_range}, " \
    "Period #{invoicing.period_between}, "
  end
end
