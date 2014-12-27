require 'rails_helper'

RSpec.describe Invoicing, type: :model do
  it('is valid') { expect(invoicing_new).to be_valid }
  describe 'validates presence' do
    it 'property_range' do
      expect(invoicing_new property_range: nil).to_not be_valid
    end
    it 'period_first' do
      expect(invoicing_new period_first: nil).to_not be_valid
    end
    it 'period_last' do
      expect(invoicing_new period_last: nil).to_not be_valid
    end
    it('runs') { expect(invoicing_new runs: nil).to_not be_valid }
  end

  #
  # account_setup
  # creates database objects required for the tests
  #
  def account_setup(property_ref:, charge_month:, charge_day:)
    invoice_text_create id: 1
    cycle = cycle_new due_ons: [DueOn.new(month: charge_month, day: charge_day)]
    account_create property: property_new(human_ref: property_ref),
                   charges: [charge_new(cycle: cycle)]
  end

  describe '#actionable?' do
    it 'can be actionable' do
      invoice = Invoice.new products: [Product.new(amount: 40)]
      (invoicing = Invoicing.new).runs = [Run.new(invoices: [invoice])]

      expect(invoicing.actionable?).to be true
    end

    it 'can not be actionable' do
      invoice = Invoice.new products: [Product.new(amount: 0)]
      (invoicing = Invoicing.new).runs = [Run.new(invoices: [invoice])]

      expect(invoicing.actionable?).to be false
    end
  end

  describe '#valid_arguments?' do
    it 'can be true' do
      expect(invoicing_new).to be_valid_arguments
    end
    it 'can be false if range false' do
      expect(invoicing_new property_range: nil).to_not be_valid_arguments
    end
    it 'can be false if period false' do
      expect(invoicing_new period_first: nil, period_last: nil)
        .to_not be_valid_arguments
    end
  end

  describe '#generate' do
    it 'invoice when an account is within property and date range' do
      account_setup property_ref: 20, charge_month: 3, charge_day: 25

      invoicing = Invoicing.new property_range: '20',
                                period: Date.new(2010, 3, 1)..
                                        Date.new(2010, 5, 1)
      expect(invoicing.runs.size).to eq 0
      invoicing.generate comments: ['', '']

      expect(invoicing.runs.size).to eq 1
      expect(invoicing.runs.first.invoices.size).to eq 1
      expect(invoicing.runs.first.invoices.first.snapshot).to_not be_nil
    end

    it 'creates more than one run' do
      account_setup property_ref: 20, charge_month: 3, charge_day: 25

      invoicing = Invoicing.new property_range: '20',
                                period: Date.new(2010, 3, 1)..
                                        Date.new(2010, 5, 1)
      invoicing.generate comments: ['', '']
      invoicing.generate comments: ['', '']

      expect(invoicing.runs.size).to eq 2
    end

    it 'uses comments given to it to make invoices' do
      account_setup property_ref: 20, charge_month: 3, charge_day: 25

      invoicing = Invoicing.new property_range: '20',
                                period: Date.new(2010, 3, 1)..
                                        Date.new(2010, 5, 1)
      invoicing.generate comments: ['', '']
      invoicing.generate comments: ['a comment']
      expect(invoicing.runs.last.invoices.first.comments.first.clarify)
        .to eq 'a comment'
    end

    describe 'does not invoice account when' do
      it 'outside property_range' do
        account_setup property_ref: 6, charge_month: 3, charge_day: 25

        invoicing = Invoicing.new property_range: '20',
                                  period: Date.new(2010, 3, 1)..
                                          Date.new(2010, 5, 1)
        invoicing.generate comments: ['', '']
        expect(invoicing.runs.first.invoices).to eq []
      end
    end
  end
end
