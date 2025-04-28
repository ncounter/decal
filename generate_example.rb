require_relative 'ics_calendar'

calendar = IcsCalendar.new

# Add some events
calendar.add_all_day_event(
  date: Date.new(2025, 5, 1),
  summary: "May Day (All Day)"
)

calendar.add_time_event(
  start_time: Time.new(2025, 5, 2, 14, 0, 0),
  end_time: Time.new(2025, 5, 2, 15, 0, 0),
  summary: "Project Kickoff Meeting"
)

calendar.add_recurring_event(
  start_time: Time.new(2025, 5, 3, 9, 0, 0),
  end_time: Time.new(2025, 5, 3, 10, 0, 0),
  summary: "Weekly Sync",
  rrule: "FREQ=WEEKLY;BYDAY=FR;COUNT=5"
)

# Generate ICS file
calendar.generate("my_events.ics")
