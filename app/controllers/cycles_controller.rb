####
#
# CyclesController
#
# Why does this class exist?
#
# To allow the creation and update of charges in the accounts system
#
# How does this fit into the larger system?
#
# Cycles are used in the ledger accounts to determine when a charge becomes due
#
####
#
class CyclesController < ApplicationController
  def index
    @cycles = Cycle.by_order
  end

  def show
    @cycle = Cycle.find params[:id]
  end

  def new
    @cycle = Cycle.new cycle_type: params[:cycle_type]
    @cycle.prepare
  end

  def create
    @cycle = Cycle.new cycles_params
    @cycle.prepare
    @cycle.due_ons.day_of_month day: params[:day] if @cycle.monthly?
    if @cycle.save
      redirect_to cycles_path, flash: { save: created_message }
    else
      render :new
    end
  end

  def edit
    @cycle = Cycle.find params[:id]
    @cycle.prepare
  end

  def update
    @cycle = Cycle.find params[:id]
    @cycle.assign_attributes cycles_params
    @cycle.due_ons.day_of_month day: params[:day] if @cycle.monthly?
    if @cycle.save
      redirect_to cycles_path, flash: { save: updated_message }
    else
      render :edit
    end
  end

  def destroy
    @cycle = Cycle.find params[:id]
    cached_message = deleted_message
    @cycle.destroy
    redirect_to cycles_path, flash: { delete: cached_message }
  end

  private

  def cycles_params
    params.require(:cycle)
          .permit %i[id name charged_in order cycle_type] +
    [due_ons_attributes: due_ons_params]
  end

  def due_ons_params
    %i[id cycle_id month day show_month show_day year _destroy]
  end

  def identity
    "Cycle #{@cycle.name} #{@cycle.order}, "
  end
end
