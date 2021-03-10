require 'rails_helper'

RSpec.describe AccountDebit, type: :model do
  it 'returns #key' do
    first = described_class.new date_due: '2014-01-01', charge_type: 'Rent', property_ref: 4, amount: 6
    expect(first.key).to eq %w[2014-01-01 Rent]
  end

  it 'returns #property_refs' do
    first = described_class.new date_due: '2014-01-01', charge_type: 'Rent', property_ref: 4, amount: 6
    expect(first.property_refs_to_s).to eq '4'
  end

  it '#merge account_debit' do
    first = described_class.new date_due: '2014-01-01', charge_type: 'Rent', property_ref: 3, amount: 6
    second = described_class.new date_due: '2014-01-01', charge_type: 'Rent', property_ref: 4, amount: 6
    first.merge second
    expect(first.property_refs.elements).to eq [3, 4]
  end

  it 'uses <=> for equality' do # requires comparable
    lhs = described_class.new date_due: '2014-01-01', charge_type: 'Rent', property_ref: 4, amount: 6
    rhs = described_class.new date_due: '2014-01-01', charge_type: 'Rent', property_ref: 4, amount: 6
    expect(lhs == rhs).to eq true
  end

  describe '#<=>' do
    it 'returns 0 when equal' do
      lhs = described_class.new date_due: '2014-01-01', charge_type: 'Rent', property_ref: 4, amount: 6
      rhs = described_class.new date_due: '2014-01-01', charge_type: 'Rent', property_ref: 4, amount: 6
      expect(lhs <=> rhs).to eq(0)
    end

    describe 'returns 1 when lhs > rhs' do
      it 'compares date_due' do
        lhs = described_class.new date_due: '2014-02-01', charge_type: 'Ins', property_ref: 4, amount: 6
        rhs = described_class.new date_due: '2014-01-01', charge_type: 'Ins', property_ref: 4, amount: 6
        expect(lhs <=> rhs).to eq(1)
      end

      it 'compares charge_type' do
        lhs = described_class.new date_due: '2014-01-01', charge_type: 'ZZZ', property_ref: 4, amount: 6
        rhs = described_class.new date_due: '2014-01-01', charge_type: 'Ins', property_ref: 4, amount: 6
        expect(lhs <=> rhs).to eq(1)
      end

      it 'does not compare property ref' do
        lhs = described_class.new date_due: '2014-01-01', charge_type: 'Ins', property_ref: 5, amount: 7
        rhs = described_class.new date_due: '2014-01-01', charge_type: 'Ins', property_ref: 4, amount: 7
        expect(lhs <=> rhs).to eq(0)
      end

      it 'does not compare amount' do
        lhs = described_class.new date_due: '2014-01-01', charge_type: 'AAA', property_ref: 4, amount: 7
        rhs = described_class.new date_due: '2014-01-01', charge_type: 'AAA', property_ref: 4, amount: 6
        expect(lhs <=> rhs).to eq(0)
      end

      it 'compares date due before charge_type' do
        lhs = described_class.new date_due: '2014-01-01', charge_type: 'ZZZ', property_ref: 4, amount: 7
        rhs = described_class.new date_due: '2014-01-01', charge_type: 'AAA', property_ref: 4, amount: 7
        expect(lhs <=> rhs).to eq(1)
      end
    end

    it 'returns -1 when lhs < rhs' do
      lhs = described_class.new date_due: '2013-12-31', charge_type: 'Rent', property_ref: 4, amount: 6
      rhs = described_class.new date_due: '2014-01-01', charge_type: 'Rent', property_ref: 4, amount: 6
      expect(lhs <=> rhs).to eq(-1)
    end

    it 'returns nil when not comparable' do
      lhs = described_class.new(date_due: '2013-12-31', charge_type: 'Rent', property_ref: 4, amount: 6)
      expect(lhs <=> 37).to be_nil
    end
  end

  it '#to_s' do
    first = described_class.new date_due: '2014-01-01', charge_type: 'Rent', property_ref: 4, amount: 6
    expect(first.to_s).to eq 'key: ["2014-01-01", "Rent"] - value: due: 2014-01-01, charge: Rent, refs: 4'
  end
end
