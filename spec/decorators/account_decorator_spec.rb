require 'rails_helper'

describe AccountDecorator do
  before { Timecop.travel(Date.new(2013, 1, 31)) }
  after { Timecop.return }

  describe 'running-balance' do
    it 'keeps a working balance' do
      account = AccountDecorator.new account_and_charge_new
      account.debits.push debit_new on_date: '25/9/2012', amount: 5.00
      account.debits.push debit_new on_date: '25/9/2013', amount: 10.00
      account.credits.push credit_new on_date: '25/9/2014', amount: -12.00
      expect(account.items.map { |item| item.running_balance }).to \
        contain_exactly \
           5.00,
           15.00,
           3.00
    end
  end

  describe 'sorted' do
    let(:account) do
      account = account_new
      account.debits.push debit_new on_date: '25/3/2013'
      account.debits.push debit_new on_date: '25/9/2013'
      account.credits.push credit_new on_date: '30/4/2013'
      account.save!
      AccountDecorator.new account
    end

    it 'orders items by date' do
      expect(account.items.map { |item| item.on_date }).to contain_exactly \
        Date.new(2013, 3, 25),
        Date.new(2013, 4, 30),
        Date.new(2013, 9, 25)
    end

    it 'orders abbrev-items by date' do
      expect(account.abbrev_items.map { |item| item.on_date }).to \
        contain_exactly \
        Date.new(2013, 1, 1),
        Date.new(2013, 3, 25),
        Date.new(2013, 4, 30),
        Date.new(2013, 9, 25)
    end
  end

  context 'zero balance' do
    let(:account) do
      account = account_new
      account.save!
      AccountDecorator.new account
    end

    it 'abbrev_items' do
      expect(account.abbrev_items.first.running_balance).to eq 0.0
    end
  end

  context 'calculated balance' do
    it 'abbrev_items' do
      account = account_new
      account.debits.push debit_new on_date: '25/3/2011', amount: 10.00
      account.debits.push debit_new on_date: '25/3/2012', amount: 10.00
      account.credits.push credit_new on_date: '25/4/2012', amount: -5.50
      account.save!
      dec = AccountDecorator.new account

      expect(dec.abbrev_items.first.running_balance).to eq 14.50
    end
  end
end
