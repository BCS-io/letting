require 'rails_helper'

describe Invoicing, type: :feature do

  describe '#show' do
    it 'basic' do
      log_in admin_attributes
      invoicing_create id: 1,
                       property_range: '1-100',
                       period_first: '2014/06/30',
                       period_last: '2014/08/30'

      visit '/invoicings/1'
      expect(page.title).to eq 'Letting - View Invoicing'
      expect(page).to have_text '1-100'
    end
  end
end
