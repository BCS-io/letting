require 'rails_helper'

RSpec.describe Snapshot, type: :model do
  it 'can have a period' do
    snapshot = Snapshot.new
    snapshot.period = '2000-01-01'..'2010-01-01'

    expect(snapshot.period).to eq Date.parse('2000-01-01')..Date.parse('2010-01-01')
  end

  it 'can be debited' do
    snapshot = Snapshot.new
    snapshot.debited debits: [debit_new(charge: charge_new)]

    expect(snapshot).to be_valid
  end

  describe '#before_period' do
    it 'is the day before the invoicing range' do
      snapshot = Snapshot.new
      snapshot.period = '2000-01-01'..'2010-01-01'

      expect(snapshot.before_period).to eq Date.parse '1999-12-31'
    end
  end

  describe '#first_invoice?' do
    it 'is not invoiced if one invoice' do
      invoice = invoice_new
      snapshot = Snapshot.new
      snapshot.invoices = [invoice]

      expect(snapshot).to be_first_invoice invoice
    end

    it 'has been invoiced if more than one invoice' do
      second_invoice = invoice_new
      snapshot = Snapshot.new
      snapshot.invoices = [invoice_new, second_invoice]

      expect(snapshot).to_not be_first_invoice second_invoice
    end
  end

  describe '.match' do
    it 'finds when matching' do
      account = account_create
      snapshot_create account: account, period: '2001/01/01'..'2001/03/01'

      snap = Snapshot.find account: account, period: '2001/01/01'..'2001/03/01'

      expect(snap).to_not be_nil
    end

    it 'returns nothing when missing' do
      account = account_create

      snap = Snapshot.find account: account, period: '2001/01/01'..'2001/03/01'

      expect(snap).to be_nil
    end
  end
end
