require 'rails_helper'

# rubocop: disable Metrics/LineLength

describe Account, :ledgers, type: :model do
  it('is valid') { expect(account_new).to be_valid }

  describe 'validates' do
    it 'requires charges below the maximum allowed' do
      account = account_new
      7.times { account.charges << charge_new }

      expect(account).to_not be_valid
    end
  end

  describe 'methods' do
    before { Timecop.travel Date.new(2013, 1, 31) }
    after { Timecop.return }

    describe '#debits_coming' do
      it 'debits if accounting_period crosses a due date'  do
        ch = charge_new cycle: cycle_new(due_ons: [DueOn.new(month: 3, day: 5)])
        account = account_new charges: [ch]

        expect(account.debits_coming Date.new(2013, 3, 5)..Date.new(2013, 3, 5))
          .to eq [Debit.new(on_date: Date.new(2013, 3, 5), amount: 88.08)]
      end

      it 'no debit if accounting_period misses due date'  do
        ch = charge_new cycle: cycle_new(due_ons: [DueOn.new(month: 3, day: 5)])
        account = account_new charges: [ch]

        expect(account.debits_coming Date.new(2013, 4, 6)..Date.new(2013, 4, 6))
          .to eq []
      end
    end

    describe '#make_credits' do
      it 'empty charges, empty credits ' do
        expect(account_new.make_credits.size).to eq(0)
      end

      it 'one charge, one credit' do
        (account = account_new).charges << charge_new
        expect(account.make_credits.size).to eq(1)
      end

      it 'produces negative amounted credits' do
        (account = account_new).charges << charge_new
        expect(account.make_credits.first.amount).to be < 0
      end
    end

    describe '#exclusive' do
      it 'allows unique charges'  do
        debit = debit_new(on_date: '2013-3-25', charge: charge_new)
        account = account_new

        expect(account.exclusive query_debits: [debit]).to eq [debit]
      end
      it 'rejects duplicate charges'  do
        debit = debit_new(on_date: '2013-3-25', charge: charge_new)
        account = account_new debits: [debit]

        expect(account.exclusive query_debits: [debit]).to eq []
      end
    end
  end

  describe '#balance' do
    it 'calculates balance to_time' do
      charge = charge_create
      account = account_new
      account.debits << debit_new(on_date: '2011-3-25', amount: 10.00, charge: charge)
      account.credits << credit_new(on_date: '2012-4-25', amount: 11.00, charge: charge)
      account.save!

      expect(account.balance to_time: '2013-1-1').to eq(-1.00)
    end

    it 'ignores entries after date' do
      charge = charge_create
      account = account_new
      account.debits << debit_new(on_date: '2011-3-25', amount: 10.00, charge: charge)
      account.credits << credit_new(on_date: '2012-4-25', amount: 11.00, charge: charge)
      account.save!

      expect(account.balance to_time: '2012-4-24').to eq 10.00
    end

    it 'smoke test' do
      charge = charge_create
      account = account_new
      account.debits << debit_new(on_date: '4/3/2012', amount: 10.00, charge: charge)
      account.debits << debit_new(on_date: '4/3/2013', amount: 10.00, charge: charge)
      account.credits << credit_new(on_date: '4/3/2012', amount: 30.00, charge: charge)
      account.credits << credit_new(on_date: '4/3/2012', amount: 30.00, charge: charge)
      account.save!

      expect(account.balance to_time: '2013-4-1').to eq(-40.00)
    end
  end

  describe '.balance_all' do
    it 'calculates simple balance' do
      charge = charge_create
      account = account_new id: 3, property: property_new(id: 4)
      account.debits.push debit_new on_date: '25/3/2011',
                                    amount: 11.00,
                                    charge: charge
      account.credits.push credit_new on_date: '25/4/2012',
                                      amount: 10.00,
                                      charge: charge
      account.save!
      expect(Account.balance_all.first.amount).to eq(1.00)
    end

    it 'calculates balance when only credits' do
      charge = charge_create
      account = account_new id: 3, property: property_new(id: 4)
      account.credits.push credit_new on_date: '25/4/2012',
                                      amount: 11.00,
                                      charge: charge
      account.save!
      expect(Account.balance_all(greater_than: -12).first.amount).to eq(-11.00)
    end

    it 'calculates balance when only debits' do
      charge = charge_create
      account = account_new id: 3, property: property_new(id: 4)
      account.debits.push debit_new on_date: '25/3/2011',
                                    amount: 10.00,
                                    charge: charge
      account.save!
      expect(Account.balance_all.first.amount).to eq(10.00)
    end

    it 'calculates simple balance' do
      charge = charge_create
      account = account_new id: 3, property: property_new(id: 4)
      account.debits.push debit_new on_date: '25/3/2011',
                                    amount: 10.00,
                                    charge: charge
      account.save!
      expect(Account.balance_all(greater_than: 11).first).to be_nil
    end

    it 'smoke test' do
      charge = charge_create
      credit_1 = credit_new amount: 3, on_date: Date.new(2012, 3, 4), charge: charge
      credit_2 = credit_new amount: 1, on_date: Date.new(2013, 3, 4), charge: charge
      debit_1 = debit_new amount: 7, on_date: Date.new(2012, 3, 4), charge: charge
      debit_2 = debit_new amount: 5, on_date: Date.new(2013, 3, 4), charge: charge
      account_create credits: [credit_1, credit_2],
                     debits: [debit_1, debit_2]

      expect(Account.balance_all.first.amount).to eq(8.00)
    end

    describe 'greater_than' do
      it 'removes those accounts less than' do
        charge = charge_create
        debit = debit_new amount: 10, on_date: Date.new(2012, 3, 4), charge: charge
        credit = credit_new amount: 9, on_date: Date.new(2012, 3, 4), charge: charge
        account_create credits: [credit], debits: [debit]

        expect(Account.balance_all(greater_than: 10).size).to eq 0
      end

      it 'includes accounts greater than than' do
        charge = charge_create
        debit = debit_new amount: 20, on_date: Date.new(2012, 3, 4), charge: charge
        credit = credit_new amount: 5, on_date: Date.new(2012, 3, 4), charge: charge
        account_create credits: [credit], debits: [debit]

        expect(Account.balance_all(greater_than: 10).size).to eq 1
      end
    end
  end

  describe 'search' do
    before { property_create human_ref: 5, account: account_new }

    describe '.find_by_human_ref' do
      it('handles nil') { expect(Account.find_by_human_ref(nil)).to be_nil }
      it('matching ref') do
        expect(Account.find_by_human_ref('5')).to eq Account.first
      end
    end

    describe '.between' do
      it('handles nil') { expect(Account.between?(nil).size).to eq 0 }
      it('matching ref') { expect(Account.between?('5').size).to eq 1 }
      it('matching range') { expect(Account.between?('5-5').size).to eq 1 }
      it('unlike ref range') { expect(Account.between?('4000').size).to eq 0 }
    end
  end
end
