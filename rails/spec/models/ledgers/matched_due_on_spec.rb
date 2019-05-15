require 'rails_helper'
# rubocop: disable Lint/UselessComparison

RSpec.describe MatchedDueOn, :ledgers, :cycle, type: :model do
  describe '#<=>' do
    it 'returns 0 when equal' do
      expect(MatchedDueOn.new(2, 2) <=> MatchedDueOn.new(2, 2)).to eq(0)
    end

    it 'returns 1 when lhs > rhs' do
      expect(MatchedDueOn.new(2, 2) <=> MatchedDueOn.new(1, 2)).to eq(1)
    end

    it 'returns -1 when lhs < rhs' do
      expect(MatchedDueOn.new(2, 2) <=> MatchedDueOn.new(3, 2)).to eq(-1)
    end

    it 'returns nil when not comparable' do
      expect(MatchedDueOn.new(2, 2) <=> 37).to be_nil
    end
  end
end
