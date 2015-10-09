#####
#
# PaymentsController
#
# Restful actions on the Payments resource
#
# Payments resource covers crediting the debits that the tenants are
# charged by the debt, invoicing, system.
#
# Payments are operator generated resources. When a payment is received
# (by standing order or cheque) - it is entered into the system through
# this resource.
#
# Payments are associated with credits which offset the invoiced debits.
#
# Don't see what my options for get_ and set_
# rubocop: disable Style/AccessorMethodName
####
#
class PaymentsController < ApplicationController
  def index
    @records = Payment.includes(join_account)
               .by_booked_at
               .page(params[:page])
               .load
  end

  def show
    @payment = PaymentDecorator.new Payment.includes(join_payment_tables)
               .find params[:id]
  end

  # params[:id] is the account_id returned from search_controller
  def new
    account = Account.includes(join_property)
              .find_by_human_ref params[:account_payment_search]
    set_focus account ? 'submit' : 'payment_search'
    @payment = PaymentDecorator.new(Payment.new account: account)
    @payment.prepare
    @payment.booked_at = get_booked_on
  end

  def create
    @payment = PaymentDecorator
               .new(Payment.new(payment_params.except(:human_ref)))
    set_booked_on date: @payment.booked_at
    @payment.register_booking
    if @payment.save
      redirect_to new_payment_path, flash: { save: created_message }
    else
      render :new
    end
  end

  def edit
    @payment = PaymentDecorator.new Payment.find params[:id]
  end

  def update
    @payment = PaymentDecorator.new Payment.find params[:id]
    @payment.assign_attributes payment_params
    if @payment.save
      redirect_to new_payment_path, flash: { save: updated_message }
    else
      render :edit
    end
  end

  def destroy
    @payment = Payment.find params[:id]
    cached_message = deleted_message
    @payment.destroy
    redirect_to payments_path, flash: { delete: cached_message }
  end

  helper_method :focus?

  def focus? focus
    params[:focus_control] == focus
  end

  def set_focus focus
    params[:focus_control] = focus
  end

  private

  def get_booked_on
    session[:payments_booked_on] ||= Time.zone.today
  end

  def set_booked_on(date:)
    session[:payments_booked_on] = date
  end

  # join_NAME
  #  - specifies the relationships to be included in the result set
  #

  def join_account
    [account: [property: [:entities]]]
  end

  def join_property
    [property: [:address, :entities]]
  end

  def join_payment_tables
    [account: [property: [:address, :entities]]]
  end

  # payment_params
  #   - white listing of user supplied data as action controller forbids
  #     mass assignment until params have been specifically allowed.
  #
  def payment_params
    params.require(:payment)
      .permit %i(id account_id booked_at amount human_ref),
              credits_attributes: credit_params
  end

  def credit_params
    %i(id account_id charge_id debit_id at_time amount)
  end

  def identity
    "Payment from #{@payment.account.property.occupiers}, " \
    "Property #{@payment.account.property.human_ref}, " \
    "Amount: £#{@payment.amount}"
  end
end
