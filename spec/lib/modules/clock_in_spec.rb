require 'rails_helper'
require_relative '../../../lib/modules/clock_in'

describe ClockIn do
  it 'defaults booking_date to today' do
    expect(ClockIn.new.booking_date).to eq Time.zone.today
  end

  describe '#recorded_as' do
    describe '#initialize add_time' do
      it 'applies time if required' do
        new_time = Time.zone.local(2008, 9, 1, 12, 1, 6)
        Timecop.freeze(new_time)

        time = ClockIn.new.recorded_as booked_time: Time.zone.now.to_date,
                                       add_time: true

        expect(time).to eq Time.zone.local(2008, 9, 1, 12, 1, 6)

        Timecop.return
      end

      it 'leaves off if not required' do
        today = Time.zone.today
        puts today

        time = ClockIn.new.recorded_as booked_time: today,
                                       add_time: false

        expect(time).to eq today
        # expected: Tue, 06 Jan 2015
        # got: 2015-01-06 23:59:59.999999999 -0100
      end
    end

    it 'recorded as now when booked_time today' do
      time = ClockIn.new.recorded_as booked_time: Time.zone.today + 1.hour
      expect(time).to eq Time.zone.today + 1.hour
    end

    it 'booked in end of day when we clock in the past' do
      new_time = Time.zone.local(2008, 9, 1, 12, 1, 6)
      Timecop.freeze(new_time)

      time = ClockIn.new.recorded_as booked_time: Time.zone.now - 1.day
      expect(time)
        .to be_within(0.5).of(Time.zone.local(2008, 8, 31, 23, 59, 59, 999_999))

      Timecop.return
    end

    it 'booked in start of the day when we clock in the future' do
      new_time = Time.zone.local(2008, 8, 31, 12, 1, 6)
      Timecop.freeze(new_time)

      time = ClockIn.new.recorded_as booked_time: Time.zone.now + 1.day
      expect(time)
        .to be_within(0.5).of(Time.zone.local(2008, 9, 1, 0, 0, 0))

      Timecop.return
    end

    context 'booking_date set to another day' do
      it 'books as interday-time if time on booking_date' do
        time = ClockIn.new(booking_date: Time.zone.yesterday)
                      .recorded_as booked_time: Time.zone.yesterday + 1.hour
        expect(time).to eq Time.zone.yesterday + 1.hour
      end
    end
  end
end
