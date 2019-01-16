require 'rails_helper'

# Run#show
#
# Displays the invoicing run onto the screen. Formatted ready for printing.
#
RSpec.describe 'RunShow#show', type: :system do
  it 'basic' do
    charge = charge_new charge_type: ChargeTypes::GROUND_RENT
    setup snapshot: snapshot_new(debits: [debit_new(charge: charge)])

    visit '/runs/1'
    expect(page.title).to eq 'Letting - Run View'
    expect(page).to have_text '1984'
  end

  describe 'back page is used for Ground Rents & Garage Ground Rents only' do
    it 'displays back page for ground rents and garage ground rent only' do
      charge = charge_new charge_type: ChargeTypes::GARAGE_GROUND_RENT
      setup snapshot: snapshot_new(debits: [debit_new(charge: charge)])
      visit '/runs/1'

      # TODO: write page wrapper
      # Tests showing the page has been loaded
      expect(page).to have_text 'Act 2002'
    end

    it 'is left blank without ground rent' do
      charge = charge_new charge_type: ChargeTypes::INSURANCE
      setup snapshot: snapshot_new(debits: [debit_new(charge: charge)])
      visit '/runs/1'

      # TODO: write page wrapper
      # Tests showing the page has been loaded
      expect(page).to_not have_text 'Act 2002'
    end
  end

  def setup(snapshot:)
    log_in admin_attributes
    invoice_text_create id: 1
    invoice_text = invoice_text_create id: 2, heading1: 'Act 2002'
    (1..7).each do |guide_id|
      guide_create id: guide_id, invoice_text: invoice_text, instruction: 'inst'
    end

    property = property_create human_ref: 1984

    run_create id: 1, invoices: [invoice_create(id: 1, property: property, snapshot: snapshot)]
  end
end
