require 'rails_helper'

RSpec.describe 'Property navigate', type: :feature do
  before(:each) { log_in }

  describe 'from index page' do
    it 'goes to view' do
      client_create \
        human_ref: 90,
        properties: [property_new(human_ref: 80, account: account_new)]
      visit '/accounts/'

      first('.link-view-testing', visible: false).click

      expect(page).to have_text '80'
      expect(page.title).to eq 'Letting - View Account'
    end

    it 'goes to edit' do
      client_create \
        human_ref: 90,
        properties: [property_new(human_ref: 80, account: account_new)]
      visit '/accounts/'

      first(:link, 'Edit').click

      expect(page.title).to eq 'Letting - Edit Account'
      expect(find_field('Property ID').value.to_i).to eq 80
    end

    it 'goes to payment' do
      client_create \
        human_ref: 90,
        properties: [property_new(human_ref: 80, account: account_new)]
      visit '/accounts/'

      first(:link, 'Add New Payment').click

      expect(page.title).to eq 'Letting - New Payment'
      expect(find_field(:account_payment_search).value.to_i).to eq 80
    end
  end

  describe 'from show page' do
    it 'goes to index page' do
      property_create id: 1, account: account_new
      visit '/accounts/1'
      click_on 'Accounts'
      expect(page.title).to eq 'Letting - Accounts'
    end

    it 'goes to edit page' do
      property_create id: 1, account: account_new
      visit '/accounts/1'

      first(:link, 'Edit').click

      expect(page.title).to eq 'Letting - Edit Account'
    end
  end

  it 'from edit page to view page' do
    client_create \
      human_ref: 90,
      properties: [property_new(id: 1, human_ref: 80, account: account_new)]

    AccountPage.new.load id: 1
    click_on 'View file'
    expect(page.title).to eq 'Letting - View Account'
  end
end
