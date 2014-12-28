require 'rails_helper'

describe 'Invoice Factory' do
  describe 'default' do
    it('is valid') { expect(invoice_new).to be_valid }

    context 'makes' do
      it 'makes a invoice_text' do
        expect { invoice_new }.to change(InvoiceText, :count).by(1)
      end
    end
  end

  describe 'override' do
    it 'override snapshots - changes products' do
      debit = debit_new(amount: 15.00, charge: charge_new)
      invoice = invoice_new snapshot: snapshot_new(debits: [debit])

      expect(invoice.products.first.amount).to eq 15.00
    end
  end

  describe 'initializes from account' do
    it 'is valid' do
      expect(invoice_new).to be_valid
    end

    it 'sets invoice_date' do
      expect(invoice_new(invoice_date: '2014/07/31').invoice_date.to_s)
        .to eq '2014-07-31'
    end

    it 'sets property_ref' do
      expect(invoice_new(property: property_new(human_ref: 87)).property_ref)
        .to eq(87)
    end

    it 'sets property address' do
      property = property_new address: address_new(road: 'New Road')
      expect(invoice_new(property: property).property_address)
        .to eq "New Road\nBirmingham\nWest Midlands"
    end

    it 'sets billing address' do
      agent = agent_new(entities: [Entity.new(name: 'Prior')],
                        address:  address_new(road: 'New'))

      expect(invoice_new(property: property_new(agent: agent)).billing_address)
        .to eq "Prior\nNew\nBirmingham\nWest Midlands"
    end
  end

  describe 'create' do
    context 'default' do
      it 'is created' do
        expect { invoice_create }.to change(Invoice, :count).by(1)
      end

      context 'makes' do
        it 'makes a invoice_text' do
          expect { invoice_create }.to change(InvoiceText, :count).by(1)
        end
      end
    end

    describe 'override' do
      it 'override snapshots - changes products' do
        debit = debit_new(amount: 15.00, charge: charge_new)
        invoice = invoice_create snapshot: snapshot_new(debits: [debit])

        expect(invoice.products.first.amount).to eq 15.00
      end
    end
  end
end
