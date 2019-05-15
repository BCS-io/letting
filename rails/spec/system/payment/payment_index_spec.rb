require 'rails_helper'

class PaymentsPage
  include Capybara::DSL

  def load
    visit '/payments'
    self
  end

  def search search_string = ''
    fill_in 'payment_search', with: search_string
    click_on 'Payment Search'
    self
  end

  def delete
    click_on 'Delete'
    self
  end

  def without_payment?
    has_no_content? /Mr W. G. Grace/i
  end

  def having_payment?
    has_content? /Mr W. G. Grace/i
  end

  def deleted?
    has_content? /deleted!/i
  end
end

RSpec.describe 'Payment#index', :ledgers, type: :system do
  let(:payments_page) { PaymentsPage.new }
  before { log_in }

  it 'all' do
    property_create account: account_new(payment: payment_new)
    payments_page.load
    expect(payments_page).to be_having_payment
  end

  it '#destroys a payment' do
    property_create account: account_new(payment: payment_new)
    payments_page.load
    expect { payments_page.delete }.to change(Payment, :count).by(-1)
    expect(payments_page).to be_deleted

    expect(payments_page.title).to eq 'Letting - Payments'
  end
end
