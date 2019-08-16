require 'rails_helper'

RSpec.describe CreditDecorator do
  it 'has the #amount - keeps sign' do
    credit_dec = described_class.new credit_new amount: 20.00
    expect(credit_dec.amount).to eq '20.00'
  end

  describe 'owing' do
    it 'displays number as currency' do
      expect(described_class.new(credit_new).owing).to eq '0.00'
    end

    it 'sums debit' do
      charge = charge_new
      debit_create charge: charge, at_time: '2013-03-30', amount: 50.08
      debit_create charge: charge, at_time: '2013-06-30', amount: 50.00
      credit_dec = described_class.new credit_new charge: charge
      expect(credit_dec.owing).to eq '100.08'
    end
  end

  describe 'payment defaults' do
    it 'new credit displays owed amount' do
      charge = charge_create
      debit_create(amount: 60, charge: charge)
      credit = credit_create(amount: 30, charge: charge)
      expect(described_class.new(credit).payment).to eq '30.00'
    end

    it 'created credit displays persisted amount' do
      credit = credit_create(amount: 30, charge: charge_new)
      expect(described_class.new(credit).payment).to eq '30.00'
    end

    it 'does not use commas for editing numbers' do
      charge = charge_create
      credit = credit_create(amount: 3000, charge: charge)
      expect(described_class.new(credit).payment).to eq '3000.00'
    end
  end
end
