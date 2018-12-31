require 'rails_helper'

RSpec.describe 'Invoicing#show', type: :feature do
  it 'Main success scenario' do
    log_in
    property_create human_ref: 2, account: account_new
    invoicing_create id: 1,
                     property_range: '2-100',
                     period: '2014/06/30'..'2014/08/30'
    visit '/invoicings/1'

    expect(page.title).to eq 'Letting - View Invoicing'
    expect(page).to have_text '2-100'
  end

  describe 'deletion of runs' do
    it 'disables first deletion' do
      log_in
      property_create human_ref: 2, account: account_new
      invoicing_create id: 1,
                       property_range: '2',
                       period: '2014-6-30'..'2014-8-1'
      visit '/invoicings/1'

      within '.t-run-delete-0' do
        expect(find '.t-delete-run').to be_disabled
      end
    end

    it 'enable subsequent deletions' do
      log_in
      property_create human_ref: 2, account: account_new
      invoicing_create id: 1, property_range: '2',
                       period: '2014-6-30'..'2014-8-1',
                       runs: [run_new(invoices: [invoice_new]),
                              run_new(invoices: [invoice_new])]
      visit '/invoicings/1'

      within '.t-run-delete-1' do
        expect(find '.t-delete-run').to_not be_disabled
      end
    end
  end

  describe 'Deliver message' do
    # Deliver: false then: Not delivering. Mail Message, Invoice under Retain.
    #
    it 'informs user, if no invoice delivered and disables printing (1.a.)' do
      log_in
      property_create human_ref: 2, account: account_new
      invoice = invoice_new deliver: 'retain'
      invoicing_create id: 1,
                       property_range: '2',
                       runs: [run_new(invoices: [invoice])]
      visit '/invoicings/1'

      expect(find '#print-link').to be_disabled
      expect(page.has_content? /No invoices will be delivered./i).to be true
    end

    # Deliver: true then: Delivering. Invoice under Deliver, Retain message.
    #
    it 'do nothing, if any invoice delivered' do
      log_in
      property_create human_ref: 2, account: account_new
      invoice = invoice_new deliver: 'mail'
      invoicing_create id: 1,
                       property_range: '2',
                       runs: [run_new(invoices: [invoice])]
      visit '/invoicings/1'

      expect(find '#print-link').to_not be_disabled
      expect(page.has_no_content? /No invoices will be delivered./i).to be true
    end
  end

  describe 'Retained message' do
    it 'informs user, if no invoice retained (1.b.)' do
      log_in
      property_create human_ref: 2, account: account_new
      invoice = invoice_new deliver: 'mail'
      invoicing_create id: 1,
                       property_range: '2',
                       runs: [run_new(invoices: [invoice])]
      visit '/invoicings/1'

      expect(page.has_content? /No invoices will be retained./i).to be true
    end

    # Test 'No Invoices' message does not occur when retaining invoices.
    #
    it 'do nothing, if any invoice retained' do
      log_in
      property_create human_ref: 2, account: account_new
      invoice = invoice_new deliver: 'retain'
      invoicing_create id: 1,
                       property_range: '2',
                       runs: [run_new(invoices: [invoice])]
      visit '/invoicings/1'

      expect(page.has_no_content? /No invoices will be retained./i).to be true
    end
  end
end
