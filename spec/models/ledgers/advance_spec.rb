require 'rails_helper'

# rubocop: disable Metrics/LineLength

describe Advance, :ledgers, :range do
  it 'initializes with repeat dates' do
    repeat = Advance.new repeat_dates: [RepeatDate.new(month: 5, day: 4)]
    expect(repeat.periods.length).to eq 1
  end

  describe '#duration returns period bounding date' do
    context 'one period' do
      describe 'bounding' do
        it 'matches start period' do
          repeat = Advance.new repeat_dates: [RepeatDate.new(year: 2024, month: 9, day: 3)]
          expect(repeat.duration(within: Date.new(2024, 9, 3)))
            .to eq Date.new(2024, 9, 3)..Date.new(2025, 9, 2)
        end

        it 'matches in period' do
          repeat = Advance.new repeat_dates: [RepeatDate.new(year: 2024, month: 9, day: 3)]
          expect(repeat.duration(within: Date.new(2025, 1, 1)))
            .to eq Date.new(2024, 9, 3)..Date.new(2025, 9, 2)
        end

        it 'matches end period' do
          repeat = Advance.new repeat_dates: [RepeatDate.new(year: 2024, month: 9, day: 3)]
          expect(repeat.duration(within: Date.new(2025, 9, 2)))
            .to eq Date.new(2024, 9, 3)..Date.new(2025, 9, 2)
        end
      end

      it 'returns expect period through a leap day' do
        repeat = Advance.new repeat_dates: [RepeatDate.new(year: 2004, month: 2, day: 20)]
        expect(repeat.duration(within: Date.new(2004, 2, 20)))
          .to eq Date.new(2004, 2, 20)..Date.new(2005, 2, 19)
      end
    end

    context 'two periods' do
      it 'returns expected period' do
        repeat = Advance.new repeat_dates: [RepeatDate.new(year: 2030, month: 3, day: 5),
                                            RepeatDate.new(year: 2030, month: 9, day: 3)]
        expect(repeat.duration(within: Date.new(2030, 9, 3)))
          .to eq Date.new(2030, 9, 3)..Date.new(2031, 3, 4)
      end
    end

    it 'errors if date not found in any period' do
      repeat = Advance.new repeat_dates: [RepeatDate.new(month: 9, day: 3)]
      expect(repeat.duration within: Date.new(2014, 9, 4))
        .to be :missing_due_on
    end
  end

  describe '#periods' do
    it 'calculates periods for one repeated date' do
      repeat = Advance.new repeat_dates: [RepeatDate.new(year: 2020, month: 3, day: 8)]
      expect(repeat.periods).to eq [[RepeatDate.new(year: 2020, month: 3, day: 8), RepeatDate.new(year: 2021, month: 3, day: 7)]]
    end

    it 'calculates periods for two repeated date' do
      repeat = Advance.new repeat_dates: [RepeatDate.new(year: 2024, month: 2, day: 4),
                                          RepeatDate.new(year: 2024, month: 6, day: 8)]
      expect(repeat.periods).to eq [[RepeatDate.new(year: 2024, month: 2, day: 4), RepeatDate.new(year: 2024, month: 6, day: 7)],
                                    [RepeatDate.new(year: 2024, month: 6, day: 8), RepeatDate.new(year: 2025, month: 2, day: 3)]]
    end

    it 'calculates periods for "advance" mid-term dates' do
      repeat = Advance.new repeat_dates: [RepeatDate.new(year: 2024, month: 3, day: 26),
                                          RepeatDate.new(year: 2024, month: 9, day: 30)]
      expect(repeat.periods).to eq [[RepeatDate.new(year: 2024, month: 3, day: 26), RepeatDate.new(year: 2024, month: 9, day: 29)],
                                    [RepeatDate.new(year: 2024, month: 9, day: 30), RepeatDate.new(year: 2025, month: 3, day: 25)]]
    end

    it 'returns periods based initialized dates' do
      repeat = Advance.new repeat_dates: [RepeatDate.new(year: 2020, month: 3, day: 8)]
      expect(repeat.periods).to eq [[RepeatDate.new(year: 2020, month: 3, day: 8), RepeatDate.new(year: 2021, month: 3, day: 7)]]
    end
  end
end
