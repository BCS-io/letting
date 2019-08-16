require 'rails_helper'

RSpec.describe PaymentIndexDecorator do
  let(:source) { payment_new }
  let(:decorator) { described_class.new source }

  describe 'attributes' do
    it '#amount' do
      expect(decorator.amount).to eq '&pound;88.08'
    end
  end
end
