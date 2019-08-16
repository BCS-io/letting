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
    it('validates the boundary') do
      expect(validatable(99_999.99)).to be_valid
      expect(validatable(100_000)).not_to be_valid
      expect(validatable(-99_999.99)).to be_valid
      expect(validatable(-100_000)).not_to be_valid
    end
    it('fails zero amount') { expect(validatable amount: 0).not_to be_valid }
  end

  it 'sets error' do
    validating = validatable(-100_000.01)
    validating.valid?
    expect(validating.errors[:amount].size).to eq(1)
  end
end
