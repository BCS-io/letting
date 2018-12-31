require 'rails_helper'

RSpec.describe PaymentIndexDecorator do
  let(:source) { payment_new }
  let(:decorator) { PaymentIndexDecorator.new source }

  context 'methods' do
    it '#amount' do
      expect(decorator.amount).to eq '&pound;88.08'
    end
  end
end
