require 'rails_helper'

RSpec.describe PaymentDecorator, :payment do
  describe 'methods' do
    context 'with account' do
      it '#human_ref is returned' do
        property = property_create human_ref: 15, account: account_new
        payment = described_class.new payment_new
        payment.account_id = property.account.id

        expect(payment.human_ref).to eq 15
      end

      it '#property_decorator returns the property' do
        property = property_create account: account_new
        payment = described_class.new payment_new
        payment.account_id = property.account.id

        expect(payment.property_decorator.property).to eq property
      end
    end

    context 'without account' do
      it '#human_ref is empty' do
        expect(described_class.new(payment_new).human_ref).to eq '-'
      end
    end

    context 'without last_payment' do
      it '#human_ref is empty' do
        expect(described_class.new(payment_new).last_amount).to eq '-'
      end
    end

    describe '.todays_takings' do
      it 'returns currency number' do
        expect(described_class.new(payment_new).todays_takings)
          .to eq '&pound;0.00'
      end
    end
  end
end
