require 'rails_helper'

describe AccountCreditDecorator do
  describe 'accessors for' do
    it '#charge_type' do
      credit_dec = AccountCreditDecorator.new credit_new(on_date: '10/6/2014')
      credit_dec.charge = charge_new charge_type: 'Rent'
      expect(credit_dec.charge_type).to eq 'Rent'
    end

    it '#date is expected form' do
      credit_dec = AccountCreditDecorator.new credit_new(on_date: '10/6/2014')
      expect(credit_dec.date).to eq '10/Jun/14'
    end

    it '#due' do
      expect(AccountCreditDecorator.new(credit_new).due).to eq ''
    end

    it '#payment' do
      credit_dec = AccountCreditDecorator.new credit_new(amount: 90.15)
      expect(credit_dec.payment).to eq '90.15'
    end

    it '#amount' do
      credit_dec = AccountCreditDecorator.new credit_new(amount: 32.05)
      expect(credit_dec.amount).to eq(32.05)
    end
  end
end
