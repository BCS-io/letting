require 'rails_helper'

RSpec.describe 'Invoicing#index', type: :feature do
  before(:each) do
    log_in admin_attributes
  end

  it 'basic' do
    property_create human_ref: 2, account: account_new
    invoicing_create property_range: '1-200',
                     period: '2013-6-30'..'2013-8-30'
    visit '/invoicings/'

    expect(page.title).to eq 'Letting - Invoicings'
    expect(page).to have_text '1-200'
    expect(page).to have_text '30/Jun/13'
  end

  it 'deletes' do
    property_create human_ref: 2, account: account_new
    invoicing_create property_range: '1-200',
                     period: "#{Time.zone.now.year}-6-30"..
                             "#{Time.zone.now.year}-8-30"
    visit '/invoicings/'

    expect { click_on 'Delete' }.to change(Invoicing, :count)
    expect(page.title).to eq 'Letting - Invoicings'

    expect(page).to \
      have_text 'Range 1-200, Period 30/Jun - 30/Aug, deleted!'
  end
end
