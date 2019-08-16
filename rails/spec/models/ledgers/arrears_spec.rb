require 'rails_helper'

# rubocop: disable Metrics/LineLength

RSpec.describe Arrears, :ledgers, :range do
  it 'initializes with repeat dates' do
    repeat = described_class.new repeat_dates: [RepeatDate.new(month: 5, day: 4)]
    expect(repeat.periods.length).to eq 1
  end

  describe '#duration returns period bounding date' do
    context 'one period' do
      describe 'bounding' do
        it 'matches start period' do
          repeat = described_class.new repeat_dates: [RepeatDate.new(year: 2025, month: 3, day: 25)]

          expect(repeat.duration(within: Date.new(2024, 3, 26)))
            .to eq Date.new(2024, 3, 26)..Date.new(2025, 3, 25)
        end

        it 'matches in period' do
          repeat = described_class.new repeat_dates: [RepeatDate.new(year: 2025, month: 3, day: 25)]

          expect(repeat.duration(within: Date.new(2024, 10, 26)))
            .to eq Date.new(2024, 3, 26)..Date.new(2025, 3, 25)
        end

        it 'matches end period' do
          repeat = described_class.new repeat_dates: [RepeatDate.new(year: 2025, month: 3, day: 25)]

          expect(repeat.duration(within: Date.new(2025, 3, 25)))
            .to eq Date.new(2024, 3, 26)..Date.new(2025, 3, 25)
        end
      end
    end

    context 'two periods' do
      it 'returns expected period' do
        repeat = described_class.new repeat_dates: [RepeatDate.new(year: 2025, month: 3, day: 25),
                                                    RepeatDate.new(year: 2025, month: 9, day: 30)]
        expect(repeat.duration(within: Date.new(2025, 9, 30)))
          .to eq Date.new(2025, 3, 26)..Date.new(2025, 9, 30)
      end
    end

    it 'errors if date not found in any period' do
      repeat = described_class.new repeat_dates: [RepeatDate.new(month: 3, day: 25),
                                                  RepeatDate.new(month: 9, day: 30)]
      expect(repeat.duration within: Date.new(2014, 9, 29))
        .to be :missing_due_on
    end
  end

  describe '#periods' do
    it 'calculates periods for one repeated date' do
      repeat = described_class.new repeat_dates: [RepeatDate.new(year: 2021, month: 3, day: 8)]
      expect(repeat.periods).to eq [[RepeatDate.new(year: 2020, month: 3, day: 9), RepeatDate.new(year: 2021, month: 3, day: 8)]]
    end

    it 'calculates periods for "arrears" mid-term dates' do
      repeat = described_class.new repeat_dates: [RepeatDate.new(year: 2024, month: 6, day: 24),
                                                  RepeatDate.new(year: 2024, month: 12, day: 25)]
      expect(repeat.periods).to eq [[RepeatDate.new(year: 2023, month: 12, day: 26), RepeatDate.new(year: 2024, month: 6, day: 24)],
                                    [RepeatDate.new(year: 2024, month: 6, day: 25), RepeatDate.new(year: 2024, month: 12, day: 25)]]
    end

    it 'calculates periods for two repeated date' do
      repeat = described_class.new repeat_dates: [RepeatDate.new(year: 2025, month: 3, day: 25),
                                                  RepeatDate.new(year: 2025, month: 9, day: 29)]
      expect(repeat.periods)
        .to eq [[RepeatDate.new(year: 2024, month: 9, day: 30), RepeatDate.new(year: 2025, month: 3, day: 25)],
                [RepeatDate.new(year: 2025, month: 3, day: 26), RepeatDate.new(year: 2025, month: 9, day: 29)]]
    end
  end
end
