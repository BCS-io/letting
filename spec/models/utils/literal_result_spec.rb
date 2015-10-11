require 'rails_helper'

# rubocop: disable  Metrics/LineLength
#
describe LiteralResult do
  describe '#found?' do
    it 'is found if records set' do
      expect(LiteralResult.new(controller: 'arbitary',
                               action: 'arbitary',
                               records: 'assigned').found?).to be true
    end

    it 'is not found if records missing' do
      expect(LiteralResult.new(controller: 'arbitary',
                               action: 'arbitary',
                               records: []).found?).to be false
    end

    describe 'no_search argument' do
      it 'if true will not find anything regardless of id and records' do
        expect(LiteralResult.new(controller: 'arbitary',
                                 action: 'arbitary',
                                 records: [1],
                                 do_not_search: true).found?).to be false
      end
    end
  end

  describe 'to_params' do
    it 'defaults to controller / action' do
      expect(LiteralResult.new(controller: 'c', action: 'a').to_params)
        .to include(controller: 'c', action: 'a')
    end

    it 'returns id if single record' do
      expect(LiteralResult.new(controller: 'arbitary',
                               action: 'arbitary',
                               records: 4).to_params)
        .to include(id: 4, controller: 'arbitary', action: 'arbitary')
    end

    it 'returns records if multiple record' do
      expect(LiteralResult.new(controller: 'arbitary',
                               action: 'arbitary',
                               records: [1, 2]).to_params)
        .to include(records: [1, 2], controller: 'arbitary', action: 'arbitary')
    end
  end

  it '#to_render is composed of controller and action' do
    expect(LiteralResult.new(controller: 'c', action: 'a').to_render)
      .to eq 'c/a'
  end

  describe 'single_record?' do
    it 'returns true if single record' do
      expect(LiteralResult.new(controller: 'arbitary',
                               action: 'arbitary',
                               records: 4).single_record?)
        .to be true
    end

    it 'returns false otherwise' do
      expect(LiteralResult.new(controller: 'arbitary',
                               action: 'arbitary',
                               records: [1, 2]).single_record?)
        .to be false
    end
  end

  describe '#<=>' do
    it 'returns 0 when equal' do
      lhs = LiteralResult.new controller: 'arbitary', action: 'arbitary', records: 1,
                              do_not_search: false
      rhs = LiteralResult.new controller: 'arbitary', action: 'arbitary', records: 1,
                              do_not_search: false

      expect(lhs <=> rhs).to eq(0)
    end

    describe 'returns 1 when lhs > rhs' do
      it 'compares records' do
        lhs = LiteralResult.new controller: 'arbitary', action: 'arbitary', records: 2,
                                do_not_search: false
        rhs = LiteralResult.new controller: 'arbitary', action: 'arbitary', records: 1,
                                do_not_search: false

        expect(lhs <=> rhs).to eq(1)
      end
    end

    it 'returns -1 when lhs < rhs' do
      lhs = LiteralResult.new controller: 'arbitary', action: 'arbitary', records: 1,
                              do_not_search: false
      rhs = LiteralResult.new controller: 'arbitary', action: 'arbitary', records: 2,
                              do_not_search: false

      expect(lhs <=> rhs).to eq(-1)
    end

    it 'returns nil when not comparable' do
      expect(LiteralResult.new(controller: 'c', action: 'a') <=> 37).to be_nil
    end
  end
end
