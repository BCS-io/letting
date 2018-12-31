require 'rails_helper'

RSpec.describe 'Payment#show', type: :feature do
  before { log_in }

  it 'shows record' do
    property_create \
      account: account_new(payment: payment_new(id: 1),
                           charges: [charge_new(debits: [debit_new])])
    visit '/payments/1'
    expect(page.title).to eq 'Letting - View Payment'
  end
end
