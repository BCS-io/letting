require 'rails_helper'

describe InvoiceDecorator do
  it '#invoice_date - displays formatted date' do
    invoice_dec = InvoiceDecorator.new \
                    invoice_new invoice_date: Date.new(2010, 3, 25)
    expect(invoice_dec.invoice_date).to eq '25/Mar/10'
  end

  it '#property_address' do
    invoice_dec = InvoiceDecorator.new invoice_new
    expect(invoice_dec.property_address)
      .to eq "Edgbaston Road\nBirmingham\nWest Midlands"
  end

  it '#property_address_one_line' do
    invoice_dec = InvoiceDecorator.new invoice_new
    expect(invoice_dec.property_address_one_line)
      .to eq 'Edgbaston Road, Birmingham, West Midlands'
  end

  it '#billing_agent' do
    invoice_dec = InvoiceDecorator.new invoice_new
    expect(invoice_dec.billing_agent).to eq "Mr W. G. Grace\n"
  end

  it '#billing_first_address_line' do
    invoice_dec = InvoiceDecorator.new invoice_new
    expect(invoice_dec.billing_first_address_line).to eq "Edgbaston Road\n"
  end

  describe '#earliest_date_due' do
    it 'set to product due_date if available' do
      debit = debit_new on_date: '2010-03-25', charge: charge_new
      snapshot = snapshot_new(account: account_new, debits: [debit])

      invoice_dec = InvoiceDecorator.new invoice_new invoice_date: '2000/1/1',
                                                     snapshot: snapshot

      expect(invoice_dec.earliest_date_due).to eq '25/Mar/10'
    end

    it 'sets it to invoice_date if no products available' do
      invoice_dec = InvoiceDecorator.new invoice_new invoice_date: '2000/1/1',
                                                     snapshot: Snapshot.new

      expect(invoice_dec.earliest_date_due).to eq '01/Jan/00'
    end
  end
end
