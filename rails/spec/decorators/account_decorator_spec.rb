require 'rails_helper'

RSpec.describe AccountDecorator do
  describe 'running-balance' do
    it 'keeps a working balance' do
      charge = charge_new
      d1 = debit_new at_time: '25/9/2012', amount: 5.00, charge: charge
      d2 = debit_new at_time: '25/9/2013', amount: 10.00, charge: charge
      c1 = credit_new at_time: '25/9/2014', amount: 12.00, charge: charge
      ac = account_create charges: [charge_new], debits: [d1, d2], credits: [c1]
      account_dec = described_class.new ac

      expect(account_dec.all_items.map(&:running_balance))
        .to contain_exactly 5.00, 15.00, 3.00
    end
  end

  describe 'sorted' do
    let(:account) do
      account = account_new
      charge = charge_new
      account.debits.push debit_new charge: charge, at_time: '25/3/2013'
      account.debits.push debit_new charge: charge, at_time: '25/9/2013'
      account.credits.push credit_new charge: charge, at_time: '30/4/2013'
      account.save!
      described_class.new account
    end

    it 'orders items by date' do
      expect(account.all_items.map(&:at_time)).to contain_exactly \
        Time.zone.local(2013, 3, 25, 0, 0, 0),
        Time.zone.local(2013, 4, 30, 0, 0, 0),
        Time.zone.local(2013, 9, 25, 0, 0, 0)
    end

    it 'orders abbrev-items by date' do
      Timecop.travel(Date.new(2013, 1, 31)) do
        expect(account.abbrev_items.map(&:at_time)).to \
          contain_exactly \
            Time.zone.local(2013, 1, 1,  0, 0, 0),
            Time.zone.local(2013, 3, 25, 0, 0, 0),
            Time.zone.local(2013, 4, 30, 0, 0, 0),
            Time.zone.local(2013, 9, 25, 0, 0, 0)
      end
    end
  end

  context 'with zero balance' do
    let(:account) do
      account = account_new
      account.save!
      described_class.new account
    end

    it 'abbrev_items' do
      expect(account.abbrev_items.first.running_balance).to eq 0.0
    end
  end

  context 'with calculated balance' do
    it 'abbrev_items' do
      account = account_new
      charge = charge_new
      account.debits.push debit_new charge: charge,
                                    at_time: '25/3/2011',
                                    amount: 10.00
      account.debits.push debit_new charge: charge,
                                    at_time: '25/3/2012',
                                    amount: 10.00
      account.credits.push credit_new charge: charge,
                                      at_time: '25/4/2012',
                                      amount: 5.50
      account.save!
      dec = described_class.new account

      expect(dec.abbrev_items.first.running_balance).to eq 14.50
    end
  end
end
