####
#
# ClientsController
#
# Why does this class exist?
#
# Restful actions on the Clients resource
#
# Client resource covers name, address and properties that the clients
# own and get payments from.
####
#
class ClientsController < ApplicationController
  def index
    @records = Client.includes(:entities).by_human_ref.page(params[:page]).load
  end

  def show
    @client_payment = ClientPayment.query client_id: params[:id]
  end

  def new
    @client = Client.new
    @client.prepare_for_form
  end

  def create
    @client = Client.new clients_params
    if @client.save
      redirect_to clients_path, flash: { save: created_message }
    else
      @client.prepare_for_form
      render :new
    end
  end

  def edit
    @client = Client.find params[:id]
    @client.prepare_for_form
  end

  def update
    @client = Client.find params[:id]
    if @client.update clients_params
      redirect_to clients_path, flash: { save: updated_message }
    else
      render :edit
    end
  end

  def destroy
    @client = Client.find params[:id]
    cached_message = deleted_message
    @client.destroy
    redirect_to clients_path, flash: { delete: cached_message }
  end

  # Payment itemized by accounting periods
  # patch method for Ajax Request
  #
  def payments_itemized
    @client_payment = ClientPayment.query client_id: params[:id]
    @client_payment.details year: params[:year].to_i, month: params[:month].to_i
  end

  private

  # clients_params
  #   - white listing of user supplied data as action controller forbids
  #     mass assignment until params have been specifically allowed.
  #
  def clients_params
    params
      .require(:client)
      .permit :human_ref,
              address_attributes: address_params,
              entities_attributes: entities_params
  end

  def identity
    "Client #{@client.human_ref}, #{@client.full_names}"
  end
end
