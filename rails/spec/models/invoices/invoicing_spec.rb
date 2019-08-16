require 'rails_helper'

RSpec.describe Invoicing, type: :model do
  it 'is valid' do
    property_create human_ref: 1, account: account_new
    expect(invoicing_new).to be_valid
  end
  describe 'validates presence' do
    it 'property_range' do
      expect(invoicing_new property_range: nil).not_to be_valid
    end
    it('runs') { expect(invoicing_new runs: nil).not_to be_valid }
  end

  describe 'validates minimum_accounts' do
    it 'sets no error if invoicing covers an account' do
      account_setup(property_ref: 2222, charge_month: 3, charge_day: 5)

      invoicing = described_class.new property_range: '2222',
                                      period: '2010-3-1'..'2010-3-31'

      invoicing.valid?

      expect(invoicing.errors).not_to include(:invoice_accounts)
    end

    it 'sets an error if invoicing does not cover any accounts' do
      account_setup(property_ref: 1111, charge_month: 3, charge_day: 5)

      invoicing = described_class.new property_range: '2222',
                                      period: '2010-3-1'..'2010-3-31'

      invoicing.valid?

      expect(invoicing.errors).to include(:invoice_accounts)
    end
  end

  describe 'validate_run' do
    # it is missing this test!
  end

  describe 'accounts' do
    # it is missing this test!
  end

  describe '#actionable?' do
    it 'can be actionable' do
      invoice = Invoice.new deliver: 'mail'
      (invoicing = described_class.new).runs = [Run.new(invoices: [invoice])]

      expect(invoicing.actionable?).to be true
    end

    it 'can not be actionable' do
      invoice = Invoice.new deliver: 'forget'
      (invoicing = described_class.new).runs = [Run.new(invoices: [invoice])]

      expect(invoicing.actionable?).to be false
    end
  end

  describe '#deliverable?' do
    it 'can be deliverable' do
      invoice = Invoice.new deliver: 'mail'
      (invoicing = described_class.new).runs = [Run.new(invoices: [invoice])]

      expect(invoicing.deliverable?).to be true
    end

    it 'can not be deliverable' do
      invoice = Invoice.new deliver: 'retain'
      (invoicing = described_class.new).runs = [Run.new(invoices: [invoice])]

      expect(invoicing.deliverable?).to be false
    end
  end

  describe '#generate' do
    it 'invoice when an account is within property and date range' do
      account_setup property_ref: 20, charge_month: 3, charge_day: 25

      invoicing = described_class.new property_range: '20',
                                      period: '2010-3-1'..'2010-5-1'
      expect(invoicing.runs.size).to eq 0
      invoicing.generate

      expect(invoicing.runs.size).to eq 1
      expect(invoicing.runs.first.invoices.size).to eq 1
      expect(invoicing.runs.first.invoices.first.snapshot).not_to be_nil
    end

    context 'first runs' do
      it 'creates blue invoices' do
        account_setup property_ref: 20, charge_month: 3, charge_day: 25

        invoicing = described_class.new property_range: '20',
                                        period: '2010-3-1'..'2010-5-1'
        invoicing.generate

        expect(invoicing.runs.last.invoices.first).to be_blue
      end
    end

    context 'second runs' do
      it 'creates more than one run' do
        account_setup property_ref: 20, charge_month: 3, charge_day: 25

        invoicing = described_class.new property_range: '20',
                                        period: '2010-3-1'..'2010-5-1'
        invoicing.generate
        invoicing.generate

        expect(invoicing.runs.size).to eq 2
      end

      it 'creates red invoices' do
        account_setup property_ref: 20, charge_month: 3, charge_day: 25

        invoicing = described_class.new property_range: '20',
                                        period: '2010-3-1'..'2010-5-1'
        invoicing.generate
        invoicing.generate
        expect(invoicing.runs.last.invoices.first).to be_red
      end
    end

    it 'uses comments given to it to make invoices' do
      account_setup property_ref: 20, charge_month: 3, charge_day: 25

      invoicing = described_class.new property_range: '20',
                                      period: '2010-3-1'..'2010-5-1'
      invoicing.generate
      invoicing.generate comments: ['a comment']
      expect(invoicing.runs.last.invoices.first.comments.first.clarify)
        .to eq 'a comment'
    end

    describe 'does not invoice account when' do
      it 'outside property_range' do
        account_setup property_ref: 6, charge_month: 3, charge_day: 25

        invoicing = described_class.new property_range: '20',
                                        period: '2010-3-1'..'2010-5-1'
        invoicing.generate
        expect(invoicing.runs.first.invoices).to eq []
      end
    end
  end

  describe '#valid_arguments?' do
    it 'can be true' do
      expect(invoicing_new).to be_valid_arguments
    end
    it 'can be false if range false' do
      expect(invoicing_new property_range: nil).not_to be_valid_arguments
    end
  end

  # account_setup for tests
  # creates database objects required for the tests
  #
  def account_setup(property_ref:, charge_month:, charge_day:)
    invoice_text_create id: 1
    cycle = cycle_new due_ons: [DueOn.new(month: charge_month, day: charge_day)]
    account_create property: property_new(human_ref: property_ref),
                   charges: [charge_new(cycle: cycle)]
  end
end
