require 'rails_helper'

RSpec.describe 'InvoiceText#show', type: :system do
  before do
    log_in admin_attributes
    invoice_text_create id: 1,
                        address: address_new(road: 'High')
  end

  it 'shows the 1st page' do
    visit '/invoice_texts/1'

    expect(page.title).to eq 'Letting - View Invoice Text'
  end

  it 'has edit link' do
    visit '/invoice_texts/1'

    expect(page.title).to eq 'Letting - View Invoice Text'
    click_on('Edit')
    expect(page.title).to eq 'Letting - Edit Invoice Text'
  end
end
