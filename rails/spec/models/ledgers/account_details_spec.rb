require 'rails_helper'

RSpec.describe AccountDetails, :ledgers, type: :model do
  describe '.balanced' do
    it 'returns accounts that were balanced a time ago' do
      charge = charge_create
      account = account_new id: 3, property: property_new(id: 4)
      account.debits.push debit_new at_time: '25/3/2010',
                                    amount: 11.00,
                                    charge: charge
      account.credits.push credit_new at_time: '25/4/2011',
                                      amount: 11.00,
                                      charge: charge
      account.save!

      expect(described_class.balanced.count(:account_id).size).to eq 1
    end

    it 'does not return accounts that were imbalanced a time ago' do
      charge = charge_create
      account = account_new id: 3, property: property_new(id: 4)
      account.debits.push debit_new at_time: '25/3/2010',
                                    amount: 11.00,
                                    charge: charge

      account.save!

      expect(described_class.balanced.count(:account_id).size).to eq 0
    end

    it 'ignores recent transactions' do
      travel_to Date.new(2013, 1, 31) do
        charge = charge_create
        account = account_new id: 3, property: property_new(id: 4)
        account.debits.push debit_new at_time: '25/3/2010',
                                      amount: 11.00,
                                      charge: charge
        account.credits.push credit_new at_time: '1/1/2013',
                                        amount: 11.00,
                                        charge: charge
        account.save!

        expect(described_class.balanced.count(:account_id).size).to eq 0
      end
    end
  end

  describe '.balance_all' do
    context 'when account balances are not greater_than' do
      it 'filters out accounts with only debits' do
        charge = charge_create
        account = account_new id: 3, property: property_new(id: 4)
        account.debits.push debit_new at_time: '25/3/2011',
                                      amount: 10.00,
                                      charge: charge
        account.save!
        expect(described_class.balance_all(greater_than: 11)).to be_empty
      end

      it 'filters out accounts with debits and credits' do
        charge = charge_create
        debit = debit_new amount: 10, at_time: Date.new(2012, 3, 4), charge: charge
        credit = credit_new amount: 9, at_time: Date.new(2012, 3, 4), charge: charge
        account_create credits: [credit], debits: [debit]

        expect(described_class.balance_all(greater_than: 10)).to be_empty
      end
    end

    context 'when account balances are greater than' do
      it 'returns matching accounts' do
        charge = charge_create
        debit = debit_new amount: 20, at_time: Date.new(2012, 3, 4), charge: charge
        credit = credit_new amount: 5, at_time: Date.new(2012, 3, 4), charge: charge
        account_create credits: [credit], debits: [debit], property: property_new

        account = described_class.balance_all(greater_than: 10).to_a[0].account

        expect(account).to eq Account.first
      end

      it 'returns matching accounts when only credits' do
        charge = charge_create
        account = account_new id: 3, property: property_new(id: 4)
        account.credits.push credit_new at_time: '25/4/2012',
                                        amount: 11.00,
                                        charge: charge
        account.save!
        expect(described_class.balance_all(greater_than: -12).to_a[0].amount).to eq(-11.00)
      end

      it 'returns matching accounts when only debits' do
        charge = charge_create
        account = account_new id: 3, property: property_new(id: 4)
        account.debits.push debit_new at_time: '25/3/2011',
                                      amount: 10.00,
                                      charge: charge
        account.save!
        expect(described_class.balance_all.to_a[0].amount).to eq(10.00)
      end

      it 'returns account balance for matching accounts' do
        charge = charge_create
        account = account_new id: 3, property: property_new(id: 4)
        account.debits.push debit_new at_time: '25/3/2011',
                                      amount: 11.00,
                                      charge: charge
        account.credits.push credit_new at_time: '25/4/2012',
                                        amount: 10.00,
                                        charge: charge
        account.save!
        expect(described_class.balance_all.to_a[0].amount).to eq(1.00)
      end

      it 'returns account balance for matching accounts - smoke test' do
        charge = charge_create
        credit1 = credit_new amount: 3, at_time: Date.new(2012, 3, 4), charge: charge
        credit2 = credit_new amount: 1, at_time: Date.new(2013, 3, 4), charge: charge
        debit1 = debit_new amount: 7, at_time: Date.new(2012, 3, 4), charge: charge
        debit2 = debit_new amount: 5, at_time: Date.new(2013, 3, 4), charge: charge
        account_create credits: [credit1, credit2],
                       debits: [debit1, debit2],
                       property: property_new

        expect(described_class.balance_all.to_a[0].amount).to eq(8.00)
      end
    end
  end
end
