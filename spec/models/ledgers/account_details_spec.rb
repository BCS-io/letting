require 'rails_helper'

# rubocop: disable Metrics/LineLength

describe AccountDetails, :ledgers, type: :model do
  describe '.balance_all' do
    it 'calculates simple balance' do
      charge = charge_create
      account = account_new id: 3, property: property_new(id: 4)
      account.debits.push debit_new at_time: '25/3/2011',
                                    amount: 11.00,
                                    charge: charge
      account.credits.push credit_new at_time: '25/4/2012',
                                      amount: 10.00,
                                      charge: charge
      account.save!
      expect(AccountDetails.balance_all.first.amount).to eq(1.00)
    end

    it 'calculates balance when only credits' do
      charge = charge_create
      account = account_new id: 3, property: property_new(id: 4)
      account.credits.push credit_new at_time: '25/4/2012',
                                      amount: 11.00,
                                      charge: charge
      account.save!
      expect(AccountDetails.balance_all(greater_than: -12).first.amount).to eq(-11.00)
    end

    it 'calculates balance when only debits' do
      charge = charge_create
      account = account_new id: 3, property: property_new(id: 4)
      account.debits.push debit_new at_time: '25/3/2011',
                                    amount: 10.00,
                                    charge: charge
      account.save!
      expect(AccountDetails.balance_all.first.amount).to eq(10.00)
    end

    it 'calculates simple balance' do
      charge = charge_create
      account = account_new id: 3, property: property_new(id: 4)
      account.debits.push debit_new at_time: '25/3/2011',
                                    amount: 10.00,
                                    charge: charge
      account.save!
      expect(AccountDetails.balance_all(greater_than: 11).first).to be_nil
    end

    it 'smoke test' do
      charge = charge_create
      credit_1 = credit_new amount: 3, at_time: Date.new(2012, 3, 4), charge: charge
      credit_2 = credit_new amount: 1, at_time: Date.new(2013, 3, 4), charge: charge
      debit_1 = debit_new amount: 7, at_time: Date.new(2012, 3, 4), charge: charge
      debit_2 = debit_new amount: 5, at_time: Date.new(2013, 3, 4), charge: charge
      account_create credits: [credit_1, credit_2],
                     debits: [debit_1, debit_2],
                     property: property_new

      expect(AccountDetails.balance_all.first.amount).to eq(8.00)
    end

    describe 'greater_than' do
      it 'removes those accounts less than' do
        charge = charge_create
        debit = debit_new amount: 10, at_time: Date.new(2012, 3, 4), charge: charge
        credit = credit_new amount: 9, at_time: Date.new(2012, 3, 4), charge: charge
        account_create credits: [credit], debits: [debit]

        expect(AccountDetails.balance_all(greater_than: 10)).to be_empty
      end

      it 'includes accounts greater than' do
        charge = charge_create
        debit = debit_new amount: 20, at_time: Date.new(2012, 3, 4), charge: charge
        credit = credit_new amount: 5, at_time: Date.new(2012, 3, 4), charge: charge
        account_create credits: [credit], debits: [debit], property: property_new

        account = AccountDetails.balance_all(greater_than: 10).first.account

        expect(account).to eq Account.first
      end
    end
  end
end
