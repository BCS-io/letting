require 'spec_helper'
require_relative '../../../lib/import/day_month'

module DB
  describe DayMonth do
    context 'Converts day and month into object' do
      it 'returns a ChargeValues' do
        daymonth = DayMonth.from_day_month 1, 10
        expect(daymonth.day).to eq 1
        expect(daymonth.month).to eq 10
      end
    end
  end
end
