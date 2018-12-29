require 'rails_helper'

RSpec.describe MakeProducts, type: :model do
  describe '#products' do
    describe '#balance' do
      it 'returns a balance' do
        charge = charge_create
        debit = debit_new charge: charge, at_time: '2000-1-1', amount: 10
        account = account_create charges: [charge], debits: [debit]

        make = MakeProducts.new account: account,
                                debits: [debit]

        expect(make.products.first.balance).to eq 10
      end

      it 'includes past arrears in the balance' do
        charge = charge_create
        past_debit = debit_create charge: charge, at_time: '1999-1-1', amount: 10
        recent_debit = debit_create charge: charge, at_time: '2003-1-1', amount: 20
        account = account_create charges: [charge], debits: [past_debit, recent_debit]

        make = MakeProducts.new account: account,
                                debits: [recent_debit]

        expect(make.products.first.balance).to eq 10
        expect(make.products.second.balance).to eq 30
      end

      it 'sums products balance (with 0 arrears)' do
        charge = charge_create
        recent_debit = debit_new charge: charge, at_time: '2002-1-1', amount: 10
        next_debit = debit_new charge: charge, at_time: '2003-1-1', amount: 20
        account = account_create charges: [charge], debits: [recent_debit, next_debit]

        make = MakeProducts.new account: account,
                                debits: [recent_debit, next_debit]

        expect(make.products.first.balance).to eq 10
        expect(make.products.second.balance).to eq 30
      end
    end
  end

  describe '#state' do
    it 'forgets if no debits' do
      make = MakeProducts.new account: account_create,
                              debits: []

      expect(make.state).to eq :forget
    end

    context 'retain' do
      it 'blue invoice - retains if the account settled' do
        charge = charge_create payment_type: 'manual'
        debit = debit_create charge: charge, at_time: '2000-1-1', amount: 10
        credit = credit_new(at_time: '1998-1-1', charge: charge, amount: 11)
        account = account_create charges: [charge], debits: [debit], credits: [credit]

        make = MakeProducts.new account: account,
                                debits: [debit],
                                color: :blue

        expect(make.state).to eq :retain
      end

      it 'red invoice - retains if the account settled' do
        charge = charge_create payment_type: 'manual'
        debit1 = debit_new charge: charge, at_time: '2000-1-1', amount: 10
        credit = credit_new(at_time: '1998-1-1', charge: charge, amount: 10)
        account = account_create charges: [charge], debits: [debit1], credits: [credit]

        make = MakeProducts.new account: account,
                                debits: [debit1],
                                color: :red

        expect(make.state).to eq :retain
      end
    end

    context 'mail' do
      it 'red invoice - mailed provided there are debits' do
        charge = charge_create payment_type: 'automatic'
        debit1 = debit_new charge: charge, at_time: '2000-1-1', amount: 10
        account = account_create charges: [charge], debits: [debit1]

        make = MakeProducts.new account: account,
                                debits: [debit1],
                                color: :red

        expect(make.state).to eq :mail
      end

      context 'blue invoice' do
        it 'mails if it has debit' do
          charge = charge_create payment_type: 'manual'
          debit1 = debit_new charge: charge, at_time: '2000-1-1', amount: 10
          account = account_create charges: [charge], debits: [debit1]

          make = MakeProducts.new account: account,
                                  debits: [debit1],
                                  color: :blue

          expect(make.state).to eq :mail
        end

        it 'retain if the only debits are automated' do
          charge = charge_create payment_type: 'automatic'
          debit1 = debit_new charge: charge, at_time: '2000-1-1', amount: 10
          account = account_create charges: [charge], debits: [debit1]

          make = MakeProducts.new account: account,
                                  debits: [debit1],
                                  color: :blue

          expect(make.state).to eq :retain
        end
      end
    end
  end
end
