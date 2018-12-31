require 'rails_helper'

RSpec.describe RangeCycle, :ledgers, :range do
  it 'initializes with dates' do
    repeat = RangeCycle.for name: 'advance', dates: [Date.new(2014, 6, 5)]

    expect(repeat.periods.length).to eq 1
    expect(repeat.periods.first.first.month).to eq 6
  end

  describe '#duration' do
    describe 'finds advanced range' do
      describe 'bounding' do
        it 'matches start date' do
          repeat = RangeCycle.for name: 'advance',
                                  dates: [Date.new(2014, 6, 6)]
          expect(repeat.duration within: Date.new(2014, 6, 6))
            .to eq Date.new(2014, 6, 6)..Date.new(2015, 6, 5)
        end

        it 'matches date in range' do
          repeat = RangeCycle.for name: 'advance',
                                  dates: [Date.new(2014, 6, 6)]
          expect(repeat.duration within: Date.new(2014, 8, 8))
            .to eq Date.new(2014, 6, 6)..Date.new(2015, 6, 5)
        end

        it 'matches end date' do
          repeat = RangeCycle.for name: 'advance',
                                  dates: [Date.new(2014, 6, 6)]
          expect(repeat.duration within: Date.new(2015, 6, 5))
            .to eq Date.new(2014, 6, 6)..Date.new(2015, 6, 5)
        end
      end
    end

    it 'finds arrears range' do
      repeat = RangeCycle.for name: 'arrears',
                              dates: [Date.new(2014, 6, 6)]
      expect(repeat.duration within: Date.new(2014, 6, 6))
        .to eq Date.new(2013, 6, 7)..Date.new(2014, 6, 6)
    end

    it 'errors when due on not found' do
      repeat = RangeCycle.for name: 'advance',
                              dates: [Date.new(2014, 6, 6)]
      expect(repeat.duration within:  Date.new(2015, 6, 6))
        .to eq :missing_due_on
    end
  end
end
