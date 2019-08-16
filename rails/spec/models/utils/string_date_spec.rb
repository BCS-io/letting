require 'rails_helper'

RSpec.describe StringDate, type: :model do
  describe 'method' do
    describe 'to_date' do
      it 'for date' do
        expect(described_class.new('2000-1-1').to_date).to eq Date.new 2000, 1, 1
      end

      it 'handles empty' do
        expect(described_class.new('').to_date).to be_nil
      end

      it 'handles malformed date' do
        expect(described_class.new('2012-x').to_date).to be_nil
      end
    end
  end
end
