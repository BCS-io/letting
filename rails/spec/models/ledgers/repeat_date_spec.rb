require 'rails_helper'

RSpec.describe RepeatDate, :ledgers, :range do
  describe 'create' do
    describe 'with date' do
      it 'has expected day' do
        repeat = described_class.new date: Date.new(2014, 2, 1)
        expect(repeat.day).to eq 1
      end

      it 'has expected month' do
        repeat = described_class.new date: Date.new(2014, 2, 1)
        expect(repeat.month).to eq 2
      end

      it 'has expected year' do
        repeat = described_class.new date: Date.new(2014, 2, 1)
        expect(repeat.year).to eq 2014
      end
    end

    describe 'with day month' do
      it 'has expected day' do
        repeat = described_class.new year: 2014, month: 2, day: 1
        expect(repeat.day).to eq 1
      end

      it 'has expected month' do
        repeat = described_class.new year: 2014, month: 2, day: 1
        expect(repeat.month).to eq 2
      end

      it 'has expected year' do
        repeat = described_class.new year: 2014, month: 2, day: 1
        expect(repeat.year).to eq 2014
      end

      describe 'defaults' do
        it "has defaulted to today's day and month for with the default year" do
          repeat = described_class.new
          expect(repeat.date).to eq Date.new 2002,
                                             Time.zone.now.month,
                                             Time.zone.now.day
        end
      end
    end
  end

  describe 'method modifiers' do
    it '#yesterday - 1 day' do
      repeat = described_class.new year: 2004, month: 2, day: 2
      expect(repeat.yesterday.to_s).to eq '2004-02-01'
    end

    it '#tomorrow  + 1 day' do
      repeat = described_class.new year: 2004, month: 2, day: 2
      expect(repeat.tomorrow.to_s).to eq '2004-02-03'
    end

    it '#last_year - 1 year' do
      repeat = described_class.new year: 2004, month: 2, day: 2
      expect(repeat.last_year.to_s).to eq '2003-02-02'
    end

    it '#next_year + 1 year' do
      repeat = described_class.new year: 2004, month: 2, day: 2
      expect(repeat.next_year.to_s).to eq '2005-02-02'
    end
  end

  describe '#<=>' do
    it 'returns 0 when equal' do
      lhs = described_class.new month: 1, day: 1
      rhs = described_class.new month: 1, day: 1
      expect(lhs <=> rhs).to eq(0)
    end

    it 'returns 1 when lhs > rhs' do
      lhs = described_class.new month: 1, day: 2
      rhs = described_class.new month: 1, day: 1
      expect(lhs <=> rhs).to eq(1)
    end

    it 'returns -1 when lhs < rhs' do
      lhs = described_class.new month: 1, day: 1
      rhs = described_class.new month: 1, day: 2
      expect(lhs <=> rhs).to eq(-1)
    end

    it 'returns nil when not comparable' do
      expect(described_class.new <=> 37).to be_nil
    end
  end

  describe '#date' do
    it 'returns date' do
      expect(described_class.new(date: Date.new(2014, 2, 1)).date)
        .to eq Date.new 2014, 2, 1
    end
  end

  it 'returns object as string' do
    expect(described_class.new(date: Date.new(2014, 2, 1)).to_s)
      .to eq '2014-02-01'
  end
end
