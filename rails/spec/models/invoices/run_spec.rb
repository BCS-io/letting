require 'rails_helper'

RSpec.describe Run, type: :model do
  it('is valid') { expect(run_new).to be_valid }

  describe 'validates presence' do
    it '#invoice_date' do
      (run = run_new).invoice_date = nil
      expect(run).not_to be_valid
    end

    it '#invoices' do
      expect(run_new invoices: nil).not_to be_valid
    end
  end

  describe '#deliverable?' do
    it 'can be deliverable' do
      run = described_class.new invoices: [Invoice.new(deliver: 'mail')]

      expect(run.deliverable?).to be true
    end

    it 'can not be deliverable' do
      run = described_class.new invoices: [Invoice.new(deliver: 'retain')]

      expect(run.deliverable?).to be false
    end
  end

  describe '#deliver' do
    it 'sends invoice that has deliver attribute true' do
      expect(run_new(invoices: [invoice_new(deliver: 'mail')]).deliver.size)
        .to eq 1
    end

    it 'keeps invoice that has deliver attribute false' do
      expect(run_new(invoices: [invoice_new(deliver: 'retain')]).deliver.size)
        .to eq 0
    end

    it 'sorts on property_ref' do
      run = run_new(invoices: [Invoice.new(property_ref: 10, deliver: 'mail'),
                               Invoice.new(property_ref: 8, deliver: 'mail')])
      expect(run.deliver.map(&:property_ref)).to eq [8, 10]
    end
  end

  describe '#retain' do
    it 'keeps invoice that has deliver attribute false' do
      expect(run_new(invoices: [invoice_new(deliver: 'retain')]).retain.size)
        .to eq 1
    end

    it 'sends invoice that has deliver attribute' do
      expect(run_new(invoices: [invoice_new(deliver: 'mail')]).retain.size)
        .to eq 0
    end

    it 'sorts on property_ref' do
      run = run_new(invoices: [Invoice.new(property_ref: 10, deliver: 'retain'),
                               Invoice.new(property_ref: 8, deliver: 'retain')])
      expect(run.retain.map(&:property_ref)).to eq [8, 10]
    end
  end

  describe '#last?' do
    it 'can be last' do
      last = described_class.new(invoices: [invoice_new])
      Invoicing.new.runs = [last]

      expect(last).to be_last
    end

    it 'can not be last' do
      first = described_class.new(invoices: [invoice_new])
      last = described_class.new(invoices: [invoice_new])
      Invoicing.new.runs = [first, last]

      expect(first).not_to be_last
    end
  end
end
