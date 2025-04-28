require 'date'
require 'time'

# Sample events list with types
events = [
  {
    type: :all_day,
    date: Date.new(2025, 5, 1),
    summary: "Holiday - All Day Event"
  },
  {
    type: :time_specific,
    start: Time.new(2025, 5, 2, 14, 0, 0),
    end: Time.new(2025, 5, 2, 15, 30, 0),
    summary: "Meeting with Team"
  },
  {
    type: :recurring,
    start: Time.new(2025, 5, 3, 9, 0, 0),
    end: Time.new(2025, 5, 3, 10, 0, 0),
    summary: "Weekly Standup",
    rrule: "FREQ=WEEKLY;BYDAY=FR;COUNT=10"
  }
]

# ICS header
ics_content = <<~ICS
  BEGIN:VCALENDAR
  VERSION:2.0
  PRODID:-//YourApp//EN
  CALSCALE:GREGORIAN
ICS

# Add events
events.each_with_index do |event, index|
  uid = "#{index}-#{Time.now.to_i}@yourapp.com"
  dtstamp = Time.now.utc.strftime('%Y%m%dT%H%M%SZ')

  ics_content += "BEGIN:VEVENT\n"
  ics_content += "UID:#{uid}\n"
  ics_content += "DTSTAMP:#{dtstamp}\n"
  ics_content += "SUMMARY:#{event[:summary]}\n"

  case event[:type]
  when :all_day
    start_date = event[:date].strftime('%Y%m%d')
    end_date = (event[:date] + 1).strftime('%Y%m%d')
    ics_content += "DTSTART;VALUE=DATE:#{start_date}\n"
    ics_content += "DTEND;VALUE=DATE:#{end_date}\n"

  when :time_specific
    ics_content += "DTSTART:#{event[:start].utc.strftime('%Y%m%dT%H%M%SZ')}\n"
    ics_content += "DTEND:#{event[:end].utc.strftime('%Y%m%dT%H%M%SZ')}\n"

  when :recurring
    ics_content += "DTSTART:#{event[:start].utc.strftime('%Y%m%dT%H%M%SZ')}\n"
    ics_content += "DTEND:#{event[:end].utc.strftime('%Y%m%dT%H%M%SZ')}\n"
    ics_content += "RRULE:#{event[:rrule]}\n"
  end

  ics_content += "END:VEVENT\n"
end

# ICS footer
ics_content += "END:VCALENDAR\n"

# Write to .ics file
File.write("enhanced_events.ics", ics_content)
puts "ICS file created: enhanced_events.ics"
