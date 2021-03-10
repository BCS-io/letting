require 'rails_helper'

RSpec.describe 'LiteralSearch #go', type: :model do
  describe 'client query' do
    it 'returns client in results' do
      client = client_create human_ref: '8'
      referrer = Referrer.new controller: 'clients', action: ''

      expect(LiteralSearch.search(referrer: referrer, query: '8').go)
        .to eq LiteralResult.new(controller: 'clients', action: 'show', records: [client])
    end

    it 'returns nil when no match' do
      referrer = Referrer.new controller: 'clients', action: ''

      expect(LiteralSearch.search(referrer: referrer, query: '8').go)
        .to eq LiteralResult.no_record_found
    end
  end

  describe 'payment query' do
    it 'returns property\'s payments in results' do
      payment = payment_new credit: credit_new(amount: 30, charge: charge_new)
      account_create property: property_new(human_ref: '10'), payment: payment
      referrer = Referrer.new controller: 'payments', action: ''

      expect(LiteralSearch.search(referrer: referrer, query: '10').go)
        .to eq LiteralResult.new(controller: 'payments', action: 'index', records: payment)
    end

    it 'returns no record found when no match' do
      referrer = Referrer.new controller: 'payments', action: ''

      expect(LiteralSearch.search(referrer: referrer, query: '10').go)
        .to eq LiteralResult.no_record_found
    end

    describe 'payments_by_dates' do
      it 'returns an exact account' do
        payment = payment_new credit: credit_new(amount: 30, charge: charge_new)
        account_create property: property_new(human_ref: '10'), payment: payment
        referrer = Referrer.new controller: 'payments_by_dates', action: ''

        expect(LiteralSearch.search(referrer: referrer, query: '10').go)
          .to eq LiteralResult.new(controller: 'payments', action: 'index', records: payment)
      end

      it 'returns no record found when no match' do
        referrer = Referrer.new controller: 'payments_by_dates', action: ''

        expect(LiteralSearch.search(referrer: referrer, query: '10').go)
          .to eq LiteralResult.no_record_found
      end
    end
  end

  describe 'property query' do
    it 'returns an exact property' do
      property = property_create human_ref: '100'
      referrer = Referrer.new controller: 'properties', action: ''

      expect(LiteralSearch.search(referrer: referrer, query: '100').go)
        .to eq LiteralResult.new(controller: 'properties', action: 'show', records: [property])
    end

    it 'return nil when no match' do
      referrer = Referrer.new controller: 'properties', action: ''

      expect(LiteralSearch.search(referrer: referrer, query: '100').go)
        .to eq LiteralResult.no_record_found
    end
  end

  %w[arrears cycles users invoice_texts invoicings invoices]
    .each do |controller|
    it 'returns without search for controllers with no obvious need.' do
      referrer = Referrer.new controller: controller, action: ''

      expect(LiteralSearch.search(referrer: referrer, query: '100').go)
        .to eq LiteralResult.no_record_found
    end
  end

  it 'errors on unknown type' do
    referrer = Referrer.new controller: 'X', action: ''

    expect { LiteralSearch.search(referrer: referrer, query: 'y').go }
      .to raise_error NotImplementedError
  end

  describe 'ordering of queries' do
    it 'searches for the queried type before any other type' do
      property_create human_ref: '100'
      client = client_create human_ref: '100'
      referrer = Referrer.new controller: 'clients', action: ''

      expect(LiteralSearch.search(referrer: referrer, query: '100').go)
        .to eq LiteralResult.new(controller: 'clients', action: 'show', records: [client])
    end

    it 'returns default if queried type does not have that value.' do
      client_create human_ref: '100'
      not_a_client = property_create human_ref: '101'
      referrer = Referrer.new controller: 'clients', action: ''

      expect(LiteralSearch.search(referrer: referrer, query: '101').go)
        .to eq LiteralResult.new(controller: 'properties', action: 'show', records: [not_a_client])
    end
  end
end
