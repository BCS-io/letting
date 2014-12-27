require 'rails_helper'

RSpec.describe ProductsMaker, type: :model do
  describe '#invoice' do
    it 'can make products' do
      (snapshot = Snapshot.new).debited debits: [debit_new(charge: charge_new)]
      maker = ProductsMaker.new account: account_new,
                                invoice_date: Date.new(1999, 1, 2),
                                snapshot: snapshot
      expect(maker.invoice.first.to_s)
        .to eq 'charge_type: Ground Rent ' \
               'date_due: 2013-03-25 ' \
               'amount: 88.08 ' \
               'period: 2013-03-25..2013-06-30, '\
               'balance: '
    end

    it 'allows products with automatic payments' do
      charge = charge_new payment_type: Charge::STANDING_ORDER
      (snapshot = Snapshot.new)
        .debited debits: [debit_new(charge: charge)]

      maker = ProductsMaker.new account: account_new,
                                invoice_date: Date.new(1999, 1, 2),
                                snapshot: snapshot
      expect(maker.invoice.size).to eq 1
    end

    context 'arrears creation' do
      it 'makes arrears from deficit' do
        debit = debit_new on_date: '1999/01/01', amount: 8, charge: charge_new
        snapshot = Snapshot.new
        maker = ProductsMaker.new account: account_new(debits: [debit]),
                                  invoice_date: Date.new(1999, 1, 2),
                                  snapshot: snapshot

        expect(maker.invoice.first).to be_valid
        expect(maker.invoice.first.charge_type).to eq 'Arrears'
        expect(maker.invoice.first.to_s)
          .to eq 'charge_type: Arrears date_due: 1999-01-02 amount: 8.0 '\
                 'period: .., balance: '
      end

      it 'does not make arrears unless deficit' do
        (snapshot = Snapshot.new)
          .debited debits: [debit_new(charge: charge_new)]

        maker = ProductsMaker.new account: account_new,
                                  invoice_date: Date.new(1999, 1, 2),
                                  snapshot: snapshot
        expect(maker.invoice.first.charge_type).to_not eq 'Arrears'
      end
    end
  end
  describe '#debits?' do
    it 'true if debits include charge with manual payment' do
      charge = charge_new payment_type: Charge::PAYMENT
      (snapshot = Snapshot.new)
        .debited debits: [debit_new(charge: charge)]

      maker = ProductsMaker.new account: account_new,
                                invoice_date: Date.new(1999, 1, 2),
                                snapshot: snapshot

      expect(maker).to be_debits
    end

    it 'true if debits include charge with automatic payment' do
      charge = charge_new payment_type: Charge::STANDING_ORDER
      (snapshot = Snapshot.new)
        .debited debits: [debit_new(charge: charge)]

      maker = ProductsMaker.new account: account_new,
                                invoice_date: Date.new(1999, 1, 2),
                                snapshot: snapshot

      expect(maker).to be_debits
    end
  end
end
