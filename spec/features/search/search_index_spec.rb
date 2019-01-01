require 'rails_helper'

RSpec.describe 'Search index', type: :feature, elasticsearch: true do
  before { log_in }

  describe 'index', :search do
    it 'visits literal matches' do
      client = client_create
      property_create human_ref: 111,
                      account: account_new(charges: [charge_new]),
                      client: client
      property_create human_ref: 222,
                      account: account_new(charges: [charge_new]),
                      client: client
      visit '/accounts'
      fill_in 'search_terms', with: '222'
      click_on 'search'
      expect(page.title).to eq 'Letting - View Account'
      expect(page).to have_text '222'
    end

    it 'indexes full text search' do
      client = client_create
      property_create human_ref: 111,
                      client: client,
                      account: account_new,
                      address: address_new(county: 'Worcester')
      property_create human_ref: 222,
                      client: client,
                      account: account_new,
                      address: address_new(county: 'West Midlands')
      property_create human_ref: 333,
                      client: client,
                      account: account_new,
                      address: address_new(county: 'West Midlands')
      Property.import force: true, refresh: true
      visit '/accounts'
      fill_in 'search_terms', with: 'Wes'
      click_on 'search'
      expect(page).to_not have_text '111'
      expect(page).to have_text '222'
      expect(page).to have_text '333'
    end

    it 'handles multiple requests' do
      property_create human_ref: 111,
                      account: account_new,
                      address: address_new(county: 'Worcester')
      Property.import force: true, refresh: true
      visit '/accounts'
      fill_in 'search_terms', with: 'Wor'
      click_on 'search'
      expect(page).to have_text '111'
      click_on 'search'
      expect(page).to have_text '111'
    end

    it 'empty search returns a default result set' do
      property_create human_ref: 111, account: account_new
      Property.import force: true, refresh: true
      visit '/accounts'
      fill_in 'search_terms', with: ''
      click_on 'search'
      expect(page).to have_text '111'
    end

    it 'search not found when absent' do
      property_create human_ref: 111, account: account_new
      Property.import force: true, refresh: true
      visit '/accounts'
      fill_in 'search_terms', with: '599'
      click_on 'search'
      expect(page).to have_text 'No Matches found. Search again.'
    end

    describe 'search terms' do
      it 'remembered for literal search' do
        property_create human_ref: 111,
                        account: account_new(charges: [charge_new]),
                        client: client_new
        visit '/accounts'
        fill_in 'search_terms', with: '111'
        click_on 'search'
        expect(find_field('search_terms').value).to have_text '111'
      end

      it 'remembered for full text search' do
        property_create human_ref: 111,
                        account: account_new,
                        address: address_new(county: 'Worcester')
        Property.import force: true, refresh: true
        visit '/accounts'
        fill_in 'search_terms', with: 'Wor'
        click_on 'search'
        expect(find_field('search_terms').value).to have_text 'Wor'
      end
    end
  end
end
