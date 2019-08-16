require 'rails_helper'

RSpec.describe Account, :ledgers, type: :model do
  it('is valid') { expect(account_new).to be_valid }

  describe 'validates' do
    it 'requires charges below the maximum allowed' do
      account = account_new
      7.times { account.charges << charge_new }

      expect(account).not_to be_valid
    end
  end

  describe 'methods' do
    describe '#debits_coming' do
      it 'debits if accounting_period crosses a due date' do
        ch = charge_new cycle: cycle_new(due_ons: [DueOn.new(month: 3, day: 5)])
        account = account_new charges: [ch]

        expect(account.debits_coming '2013-3-5'..'2013-3-5')
          .to eq [Debit.new(at_time: Date.new(2013, 3, 5), amount: 88.08)]
      end

      it 'no debit if accounting_period misses due date' do
        ch = charge_new cycle: cycle_new(due_ons: [DueOn.new(month: 3, day: 5)])
        account = account_new charges: [ch]

        expect(account.debits_coming '2013-4-6'..'2013-4-6').to eq []
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
    end

    describe '#exclusive' do
      it 'allows unique charges' do
        debit = debit_new(at_time: '2013-3-25', charge: charge_new)
        account = account_new

        expect(account.exclusive query_debits: [debit]).to eq [debit]
      end
      it 'rejects duplicate charges' do
        debit = debit_new(at_time: '2013-3-25', charge: charge_new)
        account = account_new debits: [debit]

        expect(account.exclusive query_debits: [debit]).to eq []
      end
    end
  end

  describe '#balance' do
    it 'calculates balance to_time' do
      charge = charge_create
      account = account_new
      account.debits << debit_new(at_time: '2011-3-25', amount: 10.00, charge: charge)
      account.credits << credit_new(at_time: '2012-4-25', amount: 11.00, charge: charge)
      account.save!

      expect(account.balance to_time: '2013-1-1').to eq(-1.00)
    end

    it 'ignores entries after date' do
      charge = charge_create
      account = account_new
      account.debits << debit_new(at_time: '2011-3-25', amount: 10.00, charge: charge)
      account.credits << credit_new(at_time: '2012-4-25', amount: 11.00, charge: charge)
      account.save!

      expect(account.balance to_time: '2012-4-24').to eq 10.00
    end

    it 'smoke test' do
      charge = charge_create
      account = account_new
      account.debits << debit_new(at_time: '4/3/2012', amount: 10.00, charge: charge)
      account.debits << debit_new(at_time: '4/3/2013', amount: 10.00, charge: charge)
      account.credits << credit_new(at_time: '4/3/2012', amount: 30.00, charge: charge)
      account.credits << credit_new(at_time: '4/3/2012', amount: 30.00, charge: charge)
      account.save!

      expect(account.balance to_time: '2013-4-1').to eq(-40.00)
    end
  end

  describe '#balance_all_credits' do
    it 'always includes credits' do
      charge = charge_create
      account = account_new
      account.credits << credit_new(at_time: '2100/2/28', amount: 30.00, charge: charge)
      account.save!

      expect(account.balance_all_credits to_time: '2013-1-1').to eq(-30.00)
    end

    it 'calculates balance of debits to_time' do
      charge = charge_create
      account = account_new
      account.debits << debit_new(at_time: '2011-3-25', amount: 10.00, charge: charge)
      account.save!

      expect(account.balance_all_credits to_time: '2013-1-1').to eq(10.00)
    end

    it 'ignores entries after date' do
      charge = charge_create
      account = account_new
      account.debits << debit_new(at_time: '2012-4-25', amount: 10.00, charge: charge)
      account.save!

      expect(account.balance_all_credits to_time: '2012-4-24').to eq 0
    end

    it 'smoke test' do
      charge = charge_create
      account = account_new
      account.debits << debit_new(at_time: '4/3/2012', amount: 10.00, charge: charge)
      account.debits << debit_new(at_time: '4/3/2013', amount: 10.00, charge: charge)
      account.credits << credit_new(at_time: '4/3/2012', amount: 30.00, charge: charge)
      account.credits << credit_new(at_time: '4/3/2012', amount: 30.00, charge: charge)
      account.save!

      expect(account.balance_all_credits to_time: '2013-4-1').to eq(-40.00)
    end
  end

  describe 'search' do
    before { property_create human_ref: 5, account: account_new }

    describe '.find_by_human_ref' do
      it('handles nil') { expect(described_class.find_by_human_ref(nil)).to be_nil }
      it('matching ref') do
        expect(described_class.find_by_human_ref('5')).to eq described_class.first
      end
    end

    describe '.between' do
      it('handles nil') { expect(described_class.between?(nil).size).to eq 0 }
      it('matching ref') { expect(described_class.between?('5').size).to eq 1 }
      it('matching range') { expect(described_class.between?('5-5').size).to eq 1 }
      it('unlike ref range') { expect(described_class.between?('4000').size).to eq 0 }
    end
  end
end
