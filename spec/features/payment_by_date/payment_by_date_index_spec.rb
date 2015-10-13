require 'rails_helper'

class PaymentByDatesPage
  include Capybara::DSL

  def load
    visit '/payments_by_dates'
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

describe 'PaymentByDate#index', :ledgers, type: :feature do
  let(:payment_by_dates_page) { PaymentByDatesPage.new }
  before { log_in }

  it 'all' do
    property_create account: account_new(payment: payment_new)
    payment_by_dates_page.load
    expect(payment_by_dates_page).to be_having_payment
  end

  it '#destroys a payment' do
    property_create account: account_new(payment: payment_new)
    payment_by_dates_page.load
    expect { payment_by_dates_page.delete }.to change(Payment, :count).by(-1)
    expect(payment_by_dates_page).to be_deleted
    expect(payment_by_dates_page.title).to eq 'Letting - Payments by Date'
  end
end
