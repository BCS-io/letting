require 'rails_helper'

RSpec.describe 'InvoiceText#update', type: :feature do
  before(:each) do
    log_in admin_attributes
  end

  describe 'page 1' do
    it 'finds data on 1st page' do
      invoice_text_create id: 1, vat: '89', address: address_new(road: 'High')
      visit '/invoice_texts/1/edit'

      expect(page.title).to eq 'Letting - Edit Invoice Text'
      expect(find_field('VAT').value).to have_text '89'
      expect(find_field('Road').value).to have_text 'High'
    end

    it 'has views link' do
      invoice_text_create id: 1
      visit '/invoice_texts/1/edit'

      expect(page.title).to eq 'Letting - Edit Invoice Text'
      click_on('View')
      expect(page.title).to eq 'Letting - View Invoice Text'
    end
  end

  describe 'page 2' do
    it 'finds data on 2nd page and succeeds' do
      invoice_text_create id: 1
      invoice_text = invoice_text_create id: 2
      guide_create id: 1, invoice_text: invoice_text
      visit '/invoice_texts/2/edit'

      expect(page.title). to eq 'Letting - Edit Invoice Text'
      fill_in 'Subheading', with: 'Bowled Out!'
      click_on 'Update Invoice Text'
      expect(page).to have_text /created|updated/i
    end

    it 'finds data on 2nd page and errors' do
      invoice_text_create id: 2
      guide_create instruction: 'ins2'
      visit '/invoice_texts/2/edit'

      expect(page.title).to eq 'Letting - Edit Invoice Text'
      fill_in 'Main Heading', with: ''
      click_on 'Update Invoice Text'
      expect(page).to have_css '[data-role="error_messages"]'
    end
  end
end
