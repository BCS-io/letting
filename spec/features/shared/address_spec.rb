require 'rails_helper'

RSpec.describe 'Address#updates', type: :feature do
  before(:each) { log_in }

  let(:client) { ClientPage.new }
  let(:address) { AddressPage.new }

  describe 'district line' do
    it 'can show', js: true do
      client_create id: 1, address: address_new(district: '')
      client.load id: 1

      expect(address).to be_district_invisible
      address.add line: 'district'
      expect(address).to be_district_visible
    end

    it 'shows if the address already has district', js: true do
      client_create id: 1, address: address_new(district: 'Edgbaston')
      client.load id: 1

      expect(address).to be_district_visible
    end

    it 'can hide', js: true do
      client_create id: 1, address: address_new(district: 'Edgbaston')
      client.load id: 1

      address.delete line: 'district'
      expect(address).to be_district_invisible
    end
  end

  describe 'nation line' do
    it 'can show', js: true do
      client_create id: 1, address: address_new(nation: '')
      client.load id: 1

      expect(address).to be_nation_invisible
      address.add line: 'nation'
      expect(address).to be_nation_visible
    end

    it 'shows if the address already has nation', js: true do
      client_create id: 1, address: address_new(nation: 'Edgbaston')
      client.load id: 1

      expect(address).to be_nation_visible
    end

    it 'can hide', js: true do
      client_create id: 1, address: address_new(nation: 'Edgbaston')
      client.load id: 1

      address.delete line: 'nation'
      expect(address).to be_nation_invisible
    end
  end
end
