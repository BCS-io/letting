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

  describe '#go - sorting' do
    it 'properties - primary sort orders by relevence' do
      property_create human_ref: 303, address: address_new(town: 'Yorkshire'),
                      client: client_new(id: 2)
      property_create human_ref: 202, address: address_new(town: 'York'),
                      client: client_new(id: 1)
      Property.import force: true, refresh: true
      referrer = Referrer.new controller: 'properties', action: ''

      results = FullTextSearch.search(referrer: referrer, query: 'York').go
      expect(results[:records][0].address_text).to include("York\n")
      expect(results[:records][1].address_text).to include("Yorkshire\n")
    end

    it 'properties - second sort orders by human ref asc' do
      property_create human_ref: 303, address: address_new(town: 'York'),
                      client: client_new(id: 1)
      property_create human_ref: 202, address: address_new(town: 'York'),
                      client: client_new(id: 3)
      property_create human_ref: 404, address: address_new(town: 'York'),
                      client: client_new(id: 2)
      Property.import force: true, refresh: true
      referrer = Referrer.new controller: 'properties', action: ''

      results = FullTextSearch.search(referrer: referrer, query: 'York').go
      expect(results[:records][0].human_ref).to eq 202
      expect(results[:records][1].human_ref).to eq 303
      expect(results[:records][2].human_ref).to eq 404
    end

    it 'clients - primary sort orders by relevence' do
      client_create human_ref: 101,
                    entities: [Entity.new(title: 'Mr', name: 'Blackburne'),
                               Entity.new(title: 'Mr', name: 'Black')]
      client_create human_ref: 202,
                    entities: [Entity.new(title: 'Mr', name: 'Blackburne')]
      Client.import force: true, refresh: true
      referrer = Referrer.new controller: 'clients', action: ''

      results = FullTextSearch.search(referrer: referrer, query: 'Blackburne').go
      expect(results[:records][0].full_names).to include('Blackburne')
      expect(results[:records][1].full_names).to include('Mr Blackburne & Mr Black')
    end

    it 'clients - second sort orders by human_ref asc' do
      client_create human_ref: 202,
                    entities: [Entity.new(title: 'Mr', initials: 'I', name: 'Blackburne')]
      client_create human_ref: 101,
                    entities: [Entity.new(title: 'Mr', initials: 'I', name: 'Blackburne')]
      Client.import force: true, refresh: true
      referrer = Referrer.new controller: 'clients', action: ''

      results = FullTextSearch.search(referrer: referrer, query: 'Blackburne').go
      expect(results[:records][0].human_ref).to eq 101
      expect(results[:records][1].human_ref).to eq 202
    end

    it 'payments - second orders by booked_at datetime' do
      account = account_create(property: property_new(human_ref: 101))
      payment_create booked_at: Time.zone.local(2013, 1, 1, 0, 0),
                     account: account
      payment_create booked_at: Time.zone.local(2013, 6, 6, 0, 0),
                     account: account
      Payment.import force: true, refresh: true
      referrer = Referrer.new controller: 'payments', action: ''

      results = FullTextSearch.search(referrer: referrer, query: '101').go
      expect(results[:records][0].booked_at).to eq Time.zone.local(2013, 6, 6, 0, 0)
      expect(results[:records][1].booked_at).to eq Time.zone.local(2013, 1, 1, 0, 0)
    end
  end
end
