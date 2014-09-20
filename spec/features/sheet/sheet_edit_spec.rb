require 'rails_helper'

describe Sheet, type: :feature do

  before(:each) do
    log_in admin_attributes
  end

  describe '#edit page 1' do
    it 'finds data on 1st page' do
      sheet_create id: 1, vat: '89', address: address_new(road: 'High')
      visit '/sheets/1/edit'
      expect(page.title). to eq 'Letting - Edit Sheet'
      expect(find_field('VAT').value).to have_text '89'
      expect(find_field('Road').value).to have_text 'High'
    end

    it 'has views link' do
      sheet_create id: 1
      visit '/sheets/1/edit'
      expect(page.title). to eq 'Letting - Edit Sheet'
      click_on('View')
      expect(page.title). to eq 'Letting - View Sheet'
    end
  end

  describe '#edit page 2' do
    it 'finds data on 2nd page and succeeds' do
      sheet_create id: 2
      visit '/sheets/2/edit'
      expect(page.title). to eq 'Letting - Edit Sheet'
      fill_in '2nd Heading', with: 'Bowled Out!'
      click_on 'Update Invoice Text'
      expect(page). to have_text /successfully updated!/i
    end
  end

  it 'finds data on 2nd page and errors' do
    skip 'TODO: Margaret make this error'
    sheet_create id: 2
    visit '/sheets/2/edit'
    expect(page.title). to eq 'Letting - Edit Sheet'
    # One option: fill IN BLANK something that is require
    fill_in 'Invoice', with: ''
    click_on 'Update Sheet'
    expect(page).to have_css '[data-role="errors"]'
  end
end
