require 'rails_helper'

#####
#
# InvoicingPage
#
# Encapsulates the page so tests can work at a higher abstraction than capybara
# will allow.
#
class InvoicingPage
  include Capybara::DSL

  def enter
    visit '/invoicings/new'
    self
  end

  def search_term term
    fill_in 'search_terms', with: term
    self
  end

  def search
    click_on 'Search'
    self
  end

  def choose_dates
    click_on 'or choose dates'
    self
  end

  def make
    click_on 'Create Invoicing'
    self
  end

  def errored?
    has_css? '[data-role="errors"]'
  end

  def success?
    has_content? /successfully/i
  end
end

describe Invoicing, type: :feature do
  let(:invoicing_page) { InvoicingPage.new }
  before do
    Timecop.travel Date.new(2013, 6, 1)
    log_in
  end
  after  { Timecop.return }

  it 'invoices an account that matches the search' do
    cycle = cycle_new due_ons: [DueOn.new(day: 25, month: 6)]
    client = client_new
    account_create property: property_new(human_ref: 87, client: client),
                   charges: [charge_new(cycle: cycle)]

    account_create property: property_new(human_ref: 88, client: client),
                   charges: [charge_new(cycle: cycle)]
    template_create id: 1

    invoicing_page.enter
    invoicing_page.search_term('87-88').search
    invoicing_page.make
    expect(invoicing_page).to be_success
  end
end
