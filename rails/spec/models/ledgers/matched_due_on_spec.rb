require 'rails_helper'

RSpec.describe MatchedDueOn, :ledgers, :cycle, type: :model do
  describe '#<=>' do
    it 'returns 0 when equal' do
      expect(described_class.new(2, 2) <=> described_class.new(2, 2)).to eq(0)
    end

    it 'returns 1 when lhs > rhs' do
      expect(described_class.new(2, 2) <=> described_class.new(1, 2)).to eq(1)
    end

    it 'returns -1 when lhs < rhs' do
      expect(described_class.new(2, 2) <=> described_class.new(3, 2)).to eq(-1)
    end

    it 'returns nil when not comparable' do
      expect(described_class.new(2, 2) <=> 37).to be_nil
    end
  end
end
