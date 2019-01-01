require 'rails_helper'

RSpec.describe 'Invoicing#create', type: :feature do
  let(:invoicing_page) { InvoicingPage.new }
  before do
    log_in
    invoice_text_create id: 1
  end

  it 'invoices an account that matches the search' do
    Timecop.travel('2013-6-1') do
      create_account human_ref: 87,
                     cycle: cycle_new(due_ons: [DueOn.new(month: 6, day: 24)])
      invoicing_page.load

      invoicing_page.search_term('87').button 'Create'

      expect(invoicing_page).to be_success
      expect(invoicing_page.title).to eq 'Letting - View Invoicing'
    end
  end

  describe 'choose_dates' do
    it 'defaults to "or choose dates"', js: true do
      invoicing_page.load

      expect(invoicing_page).to have_link('or choose dates')
    end

    it 'toggles to "or default to"', js: true do
      invoicing_page.load.choose_dates

      expect(invoicing_page).to have_link('or default to the next 7 weeks')
    end

    it 'remembers toggle state', js: true do
      invoicing_page.load.choose_dates.button 'Create'
      invoicing_page.load

      expect(invoicing_page).to have_link('or default to the next 7 weeks')
    end
  end

  describe 'period', js: true, elasticsearch: true do
    it 'uses defaults dates' do
      Timecop.travel('2013-6-1') do
        create_account human_ref: 87,
                       cycle: cycle_new(due_ons: [DueOn.new(month: 6, day: 24)])
        invoicing_page.load.choose_dates

        expect(invoicing_page.period).to eq '2013-06-01'..'2013-07-20'

        invoicing_page.search_term('87').button 'Create'
        expect(invoicing_page).to be_success

        expect(Invoicing.first.period.to_s).to eq '2013-06-01..2013-07-20'
      end
    end

    it 'uses chosen dates' do
      Timecop.travel('2013-6-1') do
        create_account human_ref: 87,
                       cycle: cycle_new(due_ons: [DueOn.new(month: 6, day: 24)])
        invoicing_page.load.choose_dates
        # Capybara setting datetime field
        #  - set depends on what the browser expects - in our case UK date
        #
        invoicing_page.period = '10-05-2013'..'24-06-2013'

        invoicing_page.search_term('87').button 'Create'
        expect(invoicing_page).to be_success

        expect(Invoicing.first.period.to_s).to eq '2013-05-10..2013-06-24'
      end
    end

    it 'uses defaults dates if left on default choice' do
      Timecop.travel('2013-6-1') do
        create_account human_ref: 87,
                       cycle: cycle_new(due_ons: [DueOn.new(month: 6, day: 24)])
        invoicing_page.load.choose_dates
        invoicing_page.period = '2013-05-10'..'2013-06-24'

        invoicing_page.or_default

        invoicing_page.search_term('87').button 'Create'
        expect(invoicing_page).to be_success

        expect(Invoicing.first.period.to_s).to eq '2013-06-01..2013-07-20'
      end
    end

    it 'enables dates when dates are chosen' do
      Timecop.travel('2013-6-1') do
        create_account human_ref: 87,
                       cycle: cycle_new(due_ons: [DueOn.new(month: 6, day: 24)])
        invoicing_page.load.choose_dates

        expect(find_field('Start date')).to_not be_disabled
        expect(find_field('End date')).to_not be_disabled
      end
    end
  end

  describe 'invoice_date' do
    it 'defaults to today' do
      Timecop.travel('2013-6-1') do
        create_account human_ref: 87,
                       cycle: cycle_new(due_ons: [DueOn.new(month: 6, day: 24)])
        invoicing_page.load

        expect(invoicing_page.invoice_date).to eq Time.zone.today.to_s
      end
    end

    it 'saves date between invoicings' do
      Timecop.travel('2013-6-1') do
        create_account human_ref: 87,
                       cycle: cycle_new(due_ons: [DueOn.new(month: 6, day: 24)])
        invoicing_page.load

        invoicing_page.invoice_date = Time.zone.tomorrow.to_s

        invoicing_page.search_term('87').button 'Create'

        invoicing_page.load

        expect(invoicing_page.invoice_date).to eq Time.zone.tomorrow.to_s
      end
    end

    it 'saves date when it errors' do
      Timecop.travel('2013-6-1') do
        invoicing_page.load
        invoicing_page.invoice_date = Time.zone.tomorrow.to_s
        invoicing_page.search_term('87').button 'Create'

        expect(invoicing_page.invoice_date).to eq Time.zone.tomorrow.to_s
      end
    end
  end

  describe 'errors when the property range' do
    it 'excludes all existing properties (3.a.)' do
      Timecop.travel('2013-6-1') do
        invoicing_page.load
        invoicing_page.search_term('87').button 'Create'

        expect(invoicing_page).to be_excluded
      end
    end

    it 'does not include a chargeable property for the billing-period (3.b.)' do
      Timecop.travel('2013-6-1') do
        create_account human_ref: 87,
                       cycle: cycle_new(due_ons: [DueOn.new(month: 3, day: 25)])

        invoicing_page.load
        invoicing_page.search_term('87').button 'Create'

        expect(invoicing_page).to be_not_actionable
      end
    end
  end

  it 'does not invoice properties that remain in credit after billing (3.c.)' do
    Timecop.travel('2013-6-1') do
      cycle = cycle_new due_ons: [DueOn.new(month: 6, day: 25)]
      charge = charge_new(payment_type: 'manual', cycle: cycle)
      account_create property: property_new(human_ref: 9),
                     charges: [charge],
                     credits: [credit_new(charge: charge,
                                          at_time: '2000-1-1',
                                          amount: 100)]
      invoicing_page.load
      invoicing_page.search_term('9').button 'Create'

      expect(invoicing_page).to be_actionable
      expect(invoicing_page).to be_none_delivered
    end
  end

  describe 'warns on' do
    describe 'retaining mail' do
      it 'to properties that only have automatic charges. (3.d.)' do
        Timecop.travel('2013-6-1') do
          cycle = cycle_new due_ons: [DueOn.new(month: 6, day: 25)]
          account_create property: property_new(human_ref: 9),
                         charges: [charge_new(payment_type: 'automatic',
                                              cycle: cycle)]
          invoicing_page.load
          invoicing_page.search_term('9').button 'Create'

          expect(invoicing_page).to be_actionable
          expect(invoicing_page).to_not be_none_retained
        end
      end

      # The test for retaining mail is the absence of a string, a weak test.
      # This test is to bolster the weak test with one the tests for a string's
      # presence (3.d.).
      #
      it 'will not retain when cash payment due' do
        Timecop.travel('2013-6-1') do
          cycle = cycle_new due_ons: [DueOn.new(month: 6, day: 25)]
          account_create property: property_new(human_ref: 9),
                         charges: [charge_new(payment_type: 'manual',
                                              cycle: cycle)]
          invoicing_page.load
          invoicing_page.search_term('9').button 'Create'

          expect(invoicing_page).to be_actionable
          expect(invoicing_page).to be_none_retained
        end
      end
    end

    describe 'ignoring mail' do
      it 'to properties that have no charges in billing-period. (3.e.)' do
        Timecop.travel('2013-6-1') do
          create_account human_ref: 8,
                         cycle: cycle_new(due_ons: [DueOn.new(month: 5, day: 1)])
          create_account human_ref: 9,
                         cycle: cycle_new(due_ons: [DueOn.new(month: 6, day: 25)])

          invoicing_page.load
          invoicing_page.search_term('8-9').button 'Create'

          expect(invoicing_page).to be_actionable
          expect(invoicing_page).to_not be_none_ignored
        end
      end
    end
  end

  def create_account(human_ref:, cycle:)
    account_create property: property_new(human_ref: human_ref),
                   charges: [charge_new(cycle: cycle)]
  end
end
