require 'rails_helper'

describe FullTextSearch, type: :model do
  describe '#go', :search do
    it 'return default when nothing matching' do
      property_create client_id: 89
      Property.import force: true, refresh: true
      results = FullTextSearch.search(type: 'Property', query: '83875').go
      expect(results[:success]).to eq false
      expect(results[:records].first.client_id).to eq 89
      expect(results[:render]).to eq 'properties/index'
      Property.__elasticsearch__.delete_index!
    end

    it 'return property when refeerer property' do
      property_create human_ref: 10, client_id: 100
      property_create human_ref: 11, client_id: 101
      Property.import force: true, refresh: true
      results = FullTextSearch.search(type: 'Property', query: '101').go
      expect(results[:success]).to eq true
      expect(results[:records].first.client_id).to eq 101
      expect(results[:render]).to eq 'properties/index'
      Property.__elasticsearch__.delete_index!
    end

    it 'return client when refeerer client' do
      client_create human_ref: 30
      Client.import force: true, refresh: true
      results = FullTextSearch.search(type: 'Client', query: '30').go
      expect(results[:success]).to eq true
      expect(results[:records].first.human_ref).to eq 30
      expect(results[:render]).to eq 'clients/index'
      Client.__elasticsearch__.delete_index!
    end

    it 'returns payment' do
      property_create human_ref: 9,
                      account: account_new(payment: payment_new(amount: 40.35))
      Payment.import force: true, refresh: true
      results = FullTextSearch.search(type: 'Payment', query: '40.35').go
      expect(results[:success]).to eq true
      expect(results[:records].first.amount).to eq 40.35
      expect(results[:render]).to eq 'payments/add_new_payment_index'
      Payment.__elasticsearch__.delete_index!
    end
  end
end
