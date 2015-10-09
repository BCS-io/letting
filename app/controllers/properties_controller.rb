####
#
# PropertiesController
#
# Why does this class exist?
#
# Restful actions on the Properties resource
#
# How does this fit into the larger system?
#
# Properties are at the heart of the application - which accounts, tenants,
# agents / addresses are hung off and this is the managing
# controller.
#
####
#
class PropertiesController < ApplicationController
  def index
    @records = Property.includes(:address, :client, :entities)
               .by_human_ref.page(params[:page]).load
  end

  def show
    @property = PropertyDecorator.new \
      Property.includes(join_property).find params[:id]
  end

  def new
    @property = Property.new
    @property.prepare_for_form
  end

  def create
    @property = Property.new property_params
    if @property.save
      redirect_to properties_path, flash: { save: created_message }
    else
      @property.prepare_for_form
      render :new
    end
  end

  def edit
    @property = Property.find params[:id]
    @property.prepare_for_form
  end

  def update
    @property = Property.find params[:id]
    if @property.update property_params
      redirect_on_update @property
    else
      render :edit
    end
  end

  def destroy
    @property = Property.find params[:id]
    cached_message = deleted_message
    @property.destroy
    redirect_to properties_path, flash: { delete: cached_message }
  end

  private

  def redirect_on_update property
    if params[:previous]
      redirect_to [:edit, property.prev], flash: { save: updated_message }
    elsif params[:next]
      redirect_to [:edit, property.next], flash: { save: updated_message }
    else
      redirect_to properties_path, flash: { save: updated_message }
    end
  end

  # join_property
  #   - specifies the relationships to be included in the result set
  #
  def join_property
    [client: [:entities],
     account: [charges: [:cycle], credits: [:charge], debits:  [:charge]]]
  end

  # property_params
  #   - white listing of user supplied data
  #
  def property_params
    params.require(:property)
      .permit :human_ref,
              :client_id,
              address_attributes:         address_params,
              entities_attributes:        entities_params,
              agent_attributes:           agent_params,
              account_attributes:         account_params
  end

  def agent_params
    %i(id property_id authorized) + [address_attributes: address_params] +
      [entities_attributes: entities_params]
  end

  def account_params
    %i(id property_id) + [charges_attributes: charges_params]
  end

  def charges_params
    %i(id charge_type cycle_id charged_in payment_type amount activity _destroy)  # rubocop: disable  Metrics/LineLength
  end

  def identity
    property = PropertyDecorator.new @property
    "Property: #{property.human_ref},  Address: #{property.abridged_text}"
  end
end
