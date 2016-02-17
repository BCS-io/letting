require 'rails_helper'

# PrintRun#Show
#
# Printing the entire print run, where a print run is a collection of invoices
# selected in an invoicing to be printed.
#
# Printing route for printing the run directly without going through the view
# first.
#
#
describe 'PrintRun#show', type: :feature do
  it 'basic' do
    log_in admin_attributes
    invoice_text_create id: 1
    invoice_text_create id: 2, heading1: 'Act 2002'
    (1..7).each { |guide_id| guide_create id: guide_id, instruction: 'inst' }
    charge = charge_new charge_type: ChargeTypes::GROUND_RENT
    setup snapshot: snapshot_new(debits: [debit_new(charge: charge)])
    visit '/print_runs/1'

    expect(page.title).to eq 'Letting - Run View'
    expect(page).to have_text '1984'
  end

  def setup(snapshot:)
    property = property_create human_ref: 1984
    run_create id: 1, invoices: [invoice_create(property: property, snapshot: snapshot)]
  end
end
