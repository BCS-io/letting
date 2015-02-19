require 'rails_helper'

describe 'Invoicing#update', type: :feature do
  let(:invoicing_page) { InvoicingPage.new }
  before do
    log_in
    invoice_text_create id: 1
  end

  it 'updates to red invoice' do
    Timecop.travel '2013-6-1'

    create_account human_ref: 87,
                   cycle: cycle_new(due_ons: [DueOn.new(month: 6, day: 24)])
    invoicing = Invoicing.new property_range: '87',
                              period: '2010-6-1'..'2010-8-1'
    invoicing.generate
    invoicing.save!
    invoicing_page.load invoicing: invoicing

    invoicing_page.button 'Update'

    expect(invoicing_page).to be_success
    expect(invoicing_page.title).to eq 'Letting - View Invoicing'

    Timecop.return
  end

  def create_account(human_ref:, cycle:)
    account_create property: property_new(human_ref: human_ref),
                   charges: [charge_new(cycle: cycle)]
  end
end
