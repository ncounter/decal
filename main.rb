require 'date'

# List of dates (you can add more or format differently)
dates = [
  Date.new(2025, 5, 1),
  Date.new(2025, 5, 15),
  Date.new(2025, 6, 1)
]

# ICS header
ics_content = <<~ICS
  BEGIN:VCALENDAR
  VERSION:2.0
  PRODID:-//YourApp//EN
  CALSCALE:GREGORIAN
ICS

# Add each event to the ICS file
dates.each_with_index do |date, index|
  start_time = date.strftime('%Y%m%d')
  uid = "#{index}-#{start_time}@yourapp.com"

  ics_content += <<~EVENT
    BEGIN:VEVENT
    UID:#{uid}
    DTSTAMP:#{Time.now.utc.strftime('%Y%m%dT%H%M%SZ')}
    DTSTART;VALUE=DATE:#{start_time}
    DTEND;VALUE=DATE:#{(date + 1).strftime('%Y%m%d')}
    SUMMARY:Event on #{date.strftime('%B %d, %Y')}
    END:VEVENT
  EVENT
end

# ICS footer
ics_content += "END:VCALENDAR\n"

# Write to a .ics file
File.write('events.ics', ics_content)

puts "ICS file generated: events.ics"
