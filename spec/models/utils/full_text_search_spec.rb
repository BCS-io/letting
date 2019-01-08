require 'rails_helper'

RSpec.describe FullTextSearch, elasticsearch: true, type: :model do
  describe '#go', :search do
    it 'returns results' do
      property_create address: address_new(road: 'Edgeware Road')
      Property.import force: true, refresh: true
      referrer = Referrer.new controller: 'properties', action: ''

      results = FullTextSearch.search(referrer: referrer, query: 'Edgewar').go
      expect(results[:records].count).to eq 1
      expect(results[:render]).to eq 'properties/index'
    end

    it 'return property when refeerer property' do
      property_create address: address_new(road: 'Edge')
      Property.import force: true, refresh: true
      referrer = Referrer.new controller: 'properties', action: ''

      results = FullTextSearch.search(referrer: referrer, query: 'Edg').go
      expect(results[:records].first.class).to eq Property
      expect(results[:render]).to eq 'properties/index'
    end

    it 'return client when refeerer client' do
      client_create(address: address_new(road: 'High St'))
      Client.import force: true, refresh: true
      referrer = Referrer.new controller: 'clients', action: ''

      results = FullTextSearch.search(referrer: referrer, query: 'High St').go
      expect(results[:records].first.class).to eq Client
      expect(results[:render]).to eq 'clients/index'
    end

    it 'return payment when refeerer payment' do
      payment_create account: account_create(property: \
        property_new(occupiers: [Entity.new(name: 'Strauss')]))
      Payment.import force: true, refresh: true
      referrer = Referrer.new controller: 'payments', action: ''

      results = FullTextSearch.search(referrer: referrer, query: 'Strauss').go
      expect(results[:records].first.class).to eq Payment
      expect(results[:render]).to eq 'payments/index'
    end
  end
end
