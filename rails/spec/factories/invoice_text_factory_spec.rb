require 'rails_helper'

RSpec.describe 'InvoiceText Factory' do
  describe 'new' do
    # We create the object and test it has expected value
    describe 'default' do
      it 'has description' do
        expect(invoice_text_new.description).to eq 'Page 1 Invoice'
      end
      describe 'makes' do
        it 'has address' do
          expect(invoice_text_new.address).not_to be_nil
        end
      end
    end

    describe 'adds' do
      # adds guides..
    end

    describe 'overrides' do
      it 'changes description' do
        expect(invoice_text_new(description: 'new').description).to eq 'new'
      end

      it 'changes heading1' do
        expect(invoice_text_new(heading1: 'new').heading1).to eq 'new'
      end

      it 'changes address' do
        expect(invoice_text_new(address: address_new(road: 'new')).address.road)
          .to eq 'new'
      end
    end
  end

  describe 'create' do
    describe 'default' do
      it 'is valid' do
        expect { invoice_text_create }.to change(InvoiceText, :count).by(1)
      end
      describe 'makes' do
        it 'builds address' do
          expect(invoice_text_create.address).not_to be_nil
        end
      end
    end
  end
end
