require 'date'
require 'time'

class IcsCalendar
  attr_reader :events

  def initialize
    @events = []
  end

  def add_all_day_event(date:, summary:)
    @events << {
      type: :all_day,
      date: date,
      summary: summary
    }
  end

  def add_time_event(start_time:, end_time:, summary:)
    @events << {
      type: :time_specific,
      start: start_time,
      end: end_time,
      summary: summary
    }
  end

  def add_recurring_event(start_time:, end_time:, summary:, rrule:)
    @events << {
      type: :recurring,
      start: start_time,
      end: end_time,
      summary: summary,
      rrule: rrule
    }
  end

  def generate(file_name = "calendar.ics")
    content = <<~ICS
      BEGIN:VCALENDAR
      VERSION:2.0
      PRODID:-//RubyIcsGen//EN
      CALSCALE:GREGORIAN
    ICS

    @events.each_with_index do |event, index|
      uid = "#{index}-#{Time.now.to_i}@rubyics.com"
      dtstamp = Time.now.utc.strftime('%Y%m%dT%H%M%SZ')

      content += "BEGIN:VEVENT\n"
      content += "UID:#{uid}\n"
      content += "DTSTAMP:#{dtstamp}\n"
      content += "SUMMARY:#{event[:summary]}\n"

      case event[:type]
      when :all_day
        start_date = event[:date].strftime('%Y%m%d')
        end_date = (event[:date] + 1).strftime('%Y%m%d')
        content += "DTSTART;VALUE=DATE:#{start_date}\n"
        content += "DTEND;VALUE=DATE:#{end_date}\n"
      when :time_specific, :recurring
        content += "DTSTART:#{event[:start].utc.strftime('%Y%m%dT%H%M%SZ')}\n"
        content += "DTEND:#{event[:end].utc.strftime('%Y%m%dT%H%M%SZ')}\n"
        content += "RRULE:#{event[:rrule]}\n" if event[:type] == :recurring
      end

      content += "END:VEVENT\n"
    end

    content += "END:VCALENDAR\n"
    File.write(file_name, content)
    puts "ICS file saved as: #{file_name}"
  end
end
