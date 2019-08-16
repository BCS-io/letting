require 'rails_helper'

RSpec.describe SearchDate, type: :model do
  context 'when valid' do
    it 'for date' do
      expect(described_class.new('2000-1-1')).to be_valid_date
    end

    it 'handles empty' do
      expect(described_class.new('')).not_to be_valid_date
    end

    it 'handles malformed date' do
      expect(described_class.new('2012-x')).not_to be_valid_date
    end
  end
end
