require 'rails_helper'

RSpec.describe 'Payment#create', :ledgers, type: :feature do
  before { log_in }
  let(:payment_page) { PaymentPage.new }

  it 'opens payment page as expected' do
    account_create property: property_create(human_ref: 2003),
                   charges: [charge_new(debits: [debit_new(amount: 20.05)])]

    payment_page.load
    expect(payment_page.title).to eq 'Letting - New Payment'
    payment_page.human_ref('2003').search

    expect(payment_page).to be_populated_search
    expect(payment_page).to be_receivables # receivables eq debts
  end

  describe 'autofocus' do
    it 'the next step', elasticsearch: true, js: true do
      account_create property: property_create(human_ref: 2003),
                     charges: [charge_new(debits: [debit_new(amount: 20.05)])]

      Payment.import force: true, refresh: true
      payment_page.load
      expect(find_field(:account_payment_search)[:autofocus]).to be_present
      payment_page.human_ref('2003').search
      expect(find('#submit')[:autofocus]).to be_present
      payment_page.pay
      expect(find_field(:account_payment_search)[:autofocus]).to be_present
    end

    it 'stays on search when no account found', js: true do
      payment_page.load
      payment_page.human_ref('2004').search

      expect(find_field(:account_payment_search)[:autofocus]).to be_present
    end
  end

  describe 'booked_at' do
    it 'defaults to today' do
      account_create property: property_create(human_ref: 2003),
                     charges: [charge_new(debits: [debit_new(amount: 20.05)])]
      payment_page.load.human_ref('2003').search

      expect(payment_page.booked_at).to eq Time.zone.today.to_s
    end

    it 'saves date between new payments' do
      account_create property: property_create(human_ref: 2003),
                     charges: [charge_new(debits: [debit_new(amount: 20.05)])]
      payment_page.load.human_ref('2003').search

      payment_page.booked_at = Time.zone.tomorrow.to_s

      payment_page.pay.load.human_ref('2003').search

      expect(payment_page.booked_at).to eq Time.zone.tomorrow.to_s
    end
  end

  it 'payment for debit', elasticsearch: true, js: true do
    account_create property: property_create(human_ref: 2003),
                   charges: [charge_new(debits: [debit_new(amount: 20.05)])]

    payment_page.load
    payment_page.human_ref('2003').search

    expect(payment_page.credit).to eq 20.05
    payment_page.credit = 15.05
    expect(payment_page.payment).to eq 15.05
    payment_page.pay

    expect(payment_page).to be_successful
    expect(Credit.first.amount.to_d).to eq(15.05)
    expect(Payment.first.amount.to_d).to eq(15.05)
  end

  it 'displays form errors' do
    account_create property: property_create(human_ref: 2003),
                   charges: [charge_new(debits: [debit_new])]

    payment_page.load
    payment_page.human_ref('2003').search

    payment_page.credit = 100_000_000
    payment_page.pay
    expect(payment_page).to be_errored
  end
end
