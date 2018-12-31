require 'rails_helper'

RSpec.describe FullTextSearch, type: :model do
  describe '#go', :search do
    it 'return default when mismatch' do
      property_create address: address_new(road: 'Edge')
      Property.import force: true, refresh: true
      referrer = Referrer.new controller: 'properties', action: ''

      results = FullTextSearch.search(referrer: referrer, query: 'Batt').go
      expect(results[:records].count).to eq 0
      expect(results[:render]).to eq 'properties/index'
      Property.__elasticsearch__.delete_index!
    end

    it 'return property when refeerer property' do
      property_create address: address_new(road: 'Edge')
      Property.import force: true, refresh: true
      referrer = Referrer.new controller: 'properties', action: ''

      results = FullTextSearch.search(referrer: referrer, query: 'Edg').go
      expect(results[:records].first.class).to eq Property
      expect(results[:render]).to eq 'properties/index'
      Property.__elasticsearch__.delete_index!
    end

    it 'return client when refeerer client' do
      client_create human_ref: 30
      Client.import force: true, refresh: true
      referrer = Referrer.new controller: 'clients', action: ''

      results = FullTextSearch.search(referrer: referrer, query: '30').go
      expect(results[:records].first.class).to eq Client
      expect(results[:render]).to eq 'clients/index'
      Client.__elasticsearch__.delete_index!
    end
  end
end
