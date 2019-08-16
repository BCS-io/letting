require 'rails_helper'

module PriceBound
  # Class for testing Validator
  class Validatable
    include ActiveModel::Validations
    validates :amount, price_bound: true
    attr_accessor :amount

    def initialize amount
      @amount = amount
    end
  end
end

RSpec.describe PriceBoundValidator do
  def validatable amount
    PriceBound::Validatable.new amount
  end

  describe 'amount' do
    it('is a number') { expect(validatable('nan')).not_to be_valid }
    it('has a max') { expect(validatable(100_000)).not_to be_valid }
    it('is valid under max') do
      expect(validatable(99_999.99)).to be_valid
    end
    it('has a min') { expect(validatable(-100_000)).not_to be_valid }
    it('is valid under max') { expect(validatable(-99_999.99)).to be_valid }
    it('fails zero amount') { expect(validatable amount: 0).not_to be_valid }
  end

  it 'sets error' do
    validating = validatable(-100_000.01)
    validating.valid?
    expect(validating.errors[:amount].size).to eq(1)
  end
end
