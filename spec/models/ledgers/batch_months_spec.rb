require 'rails_helper'

describe BatchMonths, :ledgers do
  describe 'make month as id' do
    it 'can return now' do
      batch_months = BatchMonths.make month: BatchMonths::MAR
      expect(batch_months.now).to eq 3
    end

    it 'can return first' do
      batch_months = BatchMonths.make month: BatchMonths::MAR

      expect(batch_months.first).to eq 3
    end

    it 'can return last' do
      batch_months = BatchMonths.make month: BatchMonths::MAR

      expect(batch_months.last).to eq 9
    end
  end

  it 'can return now' do
    batch_months = BatchMonths.make month: BatchMonths::MAR

    expect(batch_months.now_to_s).to eq 'Mar'
  end

  describe 'month strings' do
    it 'outputs first month' do
      batch_months = BatchMonths.make month: BatchMonths::MAR

      expect(batch_months.first_to_s).to eq 'Mar'
    end

    it 'outputs last month' do
      batch_months = BatchMonths.make month: BatchMonths::MAR

      expect(batch_months.last_to_s).to eq 'Sep'
    end
  end

  it 'converts to string' do
    batch_months = BatchMonths.make month: BatchMonths::MAR

    expect(batch_months.to_s).to eq 'Mar/Sep'
  end

  describe '#period' do
    it 'includes start of period' do
      batch_months = BatchMonths.make month: BatchMonths::MAR

      expect(batch_months.period(year: 1984).to_s)
        .to eq '1984-03-01..1984-08-31'
    end
  end

  describe '#payment_period' do
    it 'includes start of period' do
      batch_months = BatchMonths.make month: BatchMonths::MAR

      expect(batch_months.payment_period(year: 1984).to_s)
        .to eq '1984-02-01..1984-07-31'
    end
  end
end
