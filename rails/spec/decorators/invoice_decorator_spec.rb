require 'rails_helper'

RSpec.describe InvoiceDecorator do
  it '#invoice_date - displays formatted date' do
    invoice_dec = described_class.new invoice_new invoice_date: Date.new(2010, 3, 25)
    expect(invoice_dec.invoice_date).to eq '25/Mar/10'
  end

  it '#property_address' do
    invoice_dec = described_class.new invoice_new
    expect(invoice_dec.property_address).to eq "Edgbaston Road\nBirmingham\nWest Midlands"
  end

  it '#billing_agent' do
    invoice_dec = described_class.new invoice_new
    expect(invoice_dec.billing_agent).to eq "Mr W. G. Grace\n"
  end

  it '#billing_first_address_line' do
    invoice_dec = described_class.new invoice_new
    expect(invoice_dec.billing_first_address_line).to eq "Edgbaston Road\n"
  end

  describe 'billing address' do
    it 'pads address' do
      property = property_new(address: address_new)
      invoice_dec = described_class.new invoice_new(property: property)

      expect(invoice_dec.billing_address.lines.count).to eq 8
    end

    it 'pads address' do
      property = property_new(address:
                   address_new(house_name: 'a',
                               district: 'b',
                               postcode: 'NW1 1AA',
                               nation: 'Spain'))
      invoice_dec = described_class.new invoice_new(property: property)

      expect(invoice_dec.billing_address.lines.count).to eq 8
    end
  end

  describe '#products_display' do
    it 'returns products if it has debits' do
      debit = debit_new(amount: 8, charge: charge_new)
      dec = described_class.new invoice_new snapshot: snapshot_new(debits: [debit])
      expect(dec.products_display).to eq 'Ground Rent £8.00'
    end

    it 'returns no charges if it has none' do
      dec = described_class.new invoice_new snapshot: snapshot_new(debits: [])
      expect(dec.products_display).to eq 'No charges'
    end
  end

  describe '#earliest_date_due' do
    it 'set to product due_date if available' do
      debit = debit_new at_time: '2010-03-25', charge: charge_new
      snapshot = snapshot_new(account: account_new, debits: [debit])

      invoice_dec = described_class.new invoice_new invoice_date: '2000/1/1',
                                                    snapshot: snapshot

      expect(invoice_dec.earliest_date_due).to eq '25/Mar/10'
    end

    it 'errors trying to find earliest date if no no products available' do
      snapshot = Snapshot.new
      snapshot.period_first = '2000-01-01'

      invoice_dec = described_class.new invoice_new invoice_date: '2000/1/1',
                                                    snapshot: snapshot

      expect { invoice_dec.earliest_date_due }.to raise_error Invoice::InvoiceMissingProducts
    end
  end
end
