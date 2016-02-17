require 'rails_helper'

RSpec.describe MakeProducts, type: :model do
  describe '#products' do
    describe '#state' do
      it 'forgets if no debits' do
        make_products = MakeProducts.new account: account_create,
                                         debits: [],
                                         invoice_date: '1999-1-1'

        expect(make_products.state).to eq :forget
      end

      it 'retains if the account settled' do
        charge = charge_create payment_type: Charge::MANUAL
        debit_1 = debit_new charge: charge, at_time: '2000-1-1', amount: 10
        account = account_create charges: [charge],
                                 debits: [debit_1],
                                 credits: [credit_new(at_time: '1998-1-1',
                                                      charge: charge,
                                                      amount: 100)]

        make_products = MakeProducts.new account: account,
                                         debits: [debit_1],
                                         invoice_date: '1999-12-31'

        expect(make_products.state).to eq :retain
      end

      it 'red invoice - mailed provided there are debits' do
        charge = charge_create payment_type: Charge::AUTOMATIC
        debit_1 = debit_new charge: charge, at_time: '2000-1-1', amount: 10
        account = account_create charges: [charge], debits: [debit_1]

        make_products = MakeProducts.new account: account,
                                         debits: [debit_1],
                                         invoice_date: '1999-1-1',
                                         color: :red

        expect(make_products.state).to eq :mail
      end

      context 'blue invoice' do
        it 'retain if the only debits are automated' do
          charge = charge_create payment_type: Charge::AUTOMATIC
          debit_1 = debit_new charge: charge, at_time: '2000-1-1', amount: 10
          account = account_create charges: [charge], debits: [debit_1]

          make_products = MakeProducts.new account: account,
                                           debits: [debit_1],
                                           invoice_date: '1999-1-1',
                                           color: :blue

          expect(make_products.state).to eq :retain
        end

        it 'mails if it has debit' do
          charge = charge_create payment_type: Charge::MANUAL
          debit_1 = debit_new charge: charge, at_time: '2000-1-1', amount: 10
          account = account_create charges: [charge], debits: [debit_1]

          make_products = MakeProducts.new account: account,
                                           debits: [debit_1],
                                           invoice_date: '1999-1-1'

          expect(make_products.state).to eq :mail
        end
      end
    end

    describe '#balance' do
      it 'returns a balance' do
        charge = charge_create
        debit_1 = debit_new charge: charge, at_time: '2000-1-1', amount: 10
        account = account_create charges: [charge], debits: [debit_1]

        make_products = MakeProducts.new account: account,
                                         debits: [debit_1],
                                         invoice_date: '1999-1-1'

        expect(make_products.products.first.balance).to eq 10
      end

      it 'includes arrears in the balance' do
        charge = charge_create
        debit_1 = debit_new charge: charge, at_time: '1999-1-1', amount: 10
        debit_2 = debit_new charge: charge, at_time: '2003-1-1', amount: 20
        account = account_create charges: [charge], debits: [debit_1, debit_2]

        make_products = MakeProducts.new account: account,
                                         debits: [debit_2],
                                         invoice_date: '2001-1-1'

        expect(make_products.products.first.balance).to eq 10
        expect(make_products.products.second.balance).to eq 30
      end

      it 'sums products balance (with 0 arrears)' do
        charge = charge_create
        debit_1 = debit_new charge: charge, at_time: '2002-1-1', amount: 10
        debit_2 = debit_new charge: charge, at_time: '2003-1-1', amount: 20
        account = account_create charges: [charge], debits: [debit_1, debit_2]

        make_products = MakeProducts.new account: account,
                                         debits: [debit_1, debit_2],
                                         invoice_date: '2001-1-1'

        expect(make_products.products.first.balance).to eq 10
        expect(make_products.products.second.balance).to eq 30
      end
    end
  end
end
