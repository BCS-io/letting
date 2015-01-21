require 'rails_helper'

RSpec.describe Snapshot, type: :model do
  it 'requires debits' do
    snapshot = Snapshot.new
    expect(snapshot).to be_valid
  end

  it 'can be debited' do
    snapshot = Snapshot.new
    snapshot.debited debits: [debit_new(charge: charge_new)]
    expect(snapshot).to be_valid
  end

  describe '#state' do
    it 'forgets if no debits' do
      snapshot = Snapshot.new
      expect(snapshot.state).to eq :forget
    end

    it 'mails if it has debit' do
      snapshot = Snapshot.new
      snapshot.debited debits: [debit_new(amount: 10, charge: charge_new)]
      expect(snapshot.state).to eq :mail
    end

    it 'retain if the only debits are automated' do
      snapshot = Snapshot.new
      charge = charge_new payment_type: Charge::STANDING_ORDER
      snapshot.debited debits: [debit_new(charge: charge)]
      expect(snapshot.state).to eq :retain
    end
  end

  describe '#products' do
    describe '#balance' do
      it 'returns a balance' do
        charge = charge_create
        debit_1 = debit_new charge: charge, at_time: '2000-1-1', amount: 10
        account = account_create charges: [charge], debits: [debit_1]
        snapshot = snapshot_new account: account
        snapshot.debited debits: [debit_1]

        products = snapshot.products invoice_date: '1999-1-1'

        expect(products.first.balance).to eq 10
      end

      it 'includes arrears in the balance' do
        charge = charge_create
        debit_1 = debit_new charge: charge, at_time: '1999-1-1', amount: 10
        debit_2 = debit_new charge: charge, at_time: '2003-1-1', amount: 20
        account = account_create charges: [charge], debits: [debit_1, debit_2]
        snapshot = snapshot_new account: account
        snapshot.debited debits: [debit_2]

        products = snapshot.products invoice_date: '2001-1-1'

        expect(products.first.balance).to eq 10
        expect(products.second.balance).to eq 30
      end

      it 'sums products balance (with 0 arrears)' do
        charge = charge_create
        debit_1 = debit_new charge: charge, at_time: '2002-1-1', amount: 10
        debit_2 = debit_new charge: charge, at_time: '2003-1-1', amount: 20
        account = account_create charges: [charge], debits: [debit_1, debit_2]
        snapshot = snapshot_new account: account
        snapshot.debited debits: [debit_1, debit_2]

        products = snapshot.products invoice_date: '2001-1-1'

        expect(products.first.balance).to eq 10
        expect(products.second.balance).to eq 30
      end
    end
  end

  describe '#only_one_invoice?' do
    it 'is not invoiced if empty' do
      snapshot = Snapshot.new
      snapshot.invoices = []
      expect(snapshot).to be_only_one_invoice
    end

    it 'is not invoiced if one invoice' do
      snapshot = Snapshot.new
      snapshot.invoices = [invoice_new]
      expect(snapshot).to be_only_one_invoice
    end

    it 'has been invoiced if more than one invoice' do
      snapshot = Snapshot.new
      snapshot.invoices = [invoice_new, invoice_new]
      expect(snapshot).to_not be_only_one_invoice
    end
  end

  describe '.match' do
    it 'finds when matching' do
      account = account_create
      snapshot_create account: account, period: '2001/01/01'..'2001/03/01'

      snap = Snapshot.match account: account, period: '2001/01/01'..'2001/03/01'

      expect(snap.size).to eq 1
    end

    it 'returns nothing when missing' do
      account = account_create

      snap = Snapshot.match account: account, period: '2001/01/01'..'2001/03/01'

      expect(snap.size).to eq 0
    end
  end
end
