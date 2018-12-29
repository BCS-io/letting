####
#
# ClockIn
#
# Recording information to the nearest possible accuracy.
#
# We are using this to register datetimes when we may not know the actual time.
#
# If we are recording time there are 3 possibilities.
# We are recording a datetime that is today - we keep this faithfully.
# We are recording a datetime in the past - we only know the date and
#   make this the last thing that occurred on that day.
# We are recording a datetime in the future - we only know the date and
#   we make this the first thing that occurred on that day.
#
###
#
class ClockIn
  attr_reader :booking_date
  def initialize(booking_date: Time.zone.today)
    @booking_date = booking_date
  end

  def recorded_as(booked_time:, add_time: false)
    booked_time = Time.zone.today if booked_time.nil?
    if add_time
      booked_time = booked_time.to_date +
                    Time.zone.now.seconds_since_midnight.seconds
    end
    return booked_time.end_of_day if at_least_yesterday? booked_time
    return booked_time.beginning_of_day if at_least_tomorrow? booked_time

    booked_time
  end

  private

  def at_least_yesterday? booked_time
    booked_time.beginning_of_day < booking_date.beginning_of_day
  end

  def at_least_tomorrow? booked_time
    booked_time.beginning_of_day > booking_date.end_of_day
  end
end
