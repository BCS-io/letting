require 'rails_helper'

describe Invoicing, type: :feature do
  before(:each) do
    log_in admin_attributes
  end

  describe '#index' do
    it 'basic' do
      property_create human_ref: 2, account: account_new
      invoicing_create property_range: '1-200',
                       period_first: '2013/06/30',
                       period_last: '2013/08/30'
      visit '/invoicings/'

      expect(page.title).to eq 'Letting - Invoicing'
      expect(page).to have_text '1-200'
      expect(page).to have_text '30/Jun/13'
    end

    it 'deletes' do
      property_create human_ref: 2, account: account_new
      invoicing_create property_range: '1-200',
                       period_first: "#{Time.zone.now.year}/06/30",
                       period_last: "#{Time.zone.now.year}/08/30"
      visit '/invoicings/'

      expect { click_on 'Delete' }.to change(Invoicing, :count)
      expect(page.title).to eq 'Letting - Invoicing'

      expect(page).to \
        have_text 'Range 1-200, Period 30/Jun - 30/Aug, deleted!'
    end
  end
end
