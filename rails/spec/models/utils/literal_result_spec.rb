require 'rails_helper'

RSpec.describe LiteralResult do
  describe 'initialize' do
    it 'returns individual items as an array' do
      expect(described_class.new(controller: 'arbitary',
                                 action: 'arbitary',
                                 records: 'assigned').records).to be_an_instance_of(Array)
    end

    it 'returns an empty array as an array' do
      expect(described_class.new(controller: 'arbitary',
                                 action: 'arbitary',
                                 records: []).records).to be_an_instance_of(Array)
    end

    it 'returns an array as an array' do
      expect(described_class.new(controller: 'arbitary',
                                 action: 'arbitary',
                                 records: ['assigned']).records).to be_an_instance_of(Array)
    end

    it 'returns null relation object as an array' do
      expect(described_class.new(controller: 'arbitary',
                                 action: 'arbitary',
                                 records: Property.none).records).to be_an_instance_of(Array)
    end
  end

  describe '#found?' do
    it 'is found if one item in an array is set' do
      expect(described_class.new(controller: 'arbitary',
                                 action: 'arbitary',
                                 records: ['assigned']).found?).to be true
    end

    it 'is not found if records missing' do
      expect(described_class.new(controller: 'arbitary',
                                 action: 'arbitary',
                                 records: []).found?).to be false
    end
  end

  describe 'to_params' do
    it 'defaults to controller / action' do
      expect(described_class.new(controller: 'c', action: 'a', records: []).to_params)
        .to include(controller: 'c', action: 'a')
    end

    it 'returns id if single record' do
      expect(described_class.new(controller: 'arbitary',
                                 action: 'arbitary',
                                 records: [4]).to_params)
        .to include(id: 4, controller: 'arbitary', action: 'arbitary')
    end

    it 'returns records if multiple record' do
      expect(described_class.new(controller: 'arbitary',
                                 action: 'arbitary',
                                 records: [1, 2]).to_params)
        .to include(records: [1, 2], controller: 'arbitary', action: 'arbitary')
    end
  end

  it '#to_render is composed of controller and action' do
    expect(described_class.new(controller: 'c', action: 'a', records: []).to_render)
      .to eq 'c/a'
  end

  describe 'single_record?' do
    it 'returns true if single record' do
      expect(described_class.new(controller: 'arbitary',
                                 action: 'arbitary',
                                 records: [1]).single_record?)
        .to be true
    end

    it 'returns false otherwise' do
      expect(described_class.new(controller: 'arbitary',
                                 action: 'arbitary',
                                 records: [1, 2]).single_record?)
        .to be false
    end
  end

  describe '#<=>' do
    it 'returns 0 when equal' do
      lhs = described_class.new controller: 'arbitary', action: 'arbitary', records: [1]
      rhs = described_class.new controller: 'arbitary', action: 'arbitary', records: [1]

      expect(lhs <=> rhs).to eq(0)
    end

    describe 'returns 1 when lhs > rhs' do
      it 'compares records' do
        lhs = described_class.new controller: 'arbitary', action: 'arbitary', records: [2]
        rhs = described_class.new controller: 'arbitary', action: 'arbitary', records: [1]

        expect(lhs <=> rhs).to eq(1)
      end
    end

    it 'returns -1 when lhs < rhs' do
      lhs = described_class.new controller: 'arbitary', action: 'arbitary', records: [1]
      rhs = described_class.new controller: 'arbitary', action: 'arbitary', records: [2]

      expect(lhs <=> rhs).to eq(-1)
    end

    it 'returns nil when not comparable' do
      expect(described_class.new(controller: 'c', action: 'a', records: []) <=> 37).to be_nil
    end
  end
end
