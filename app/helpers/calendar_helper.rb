module CalendarHelper
  def calendar(options = {}, &block)
    date = options[:date] || Date.today
    events = options[:events] || {}
    Calendar.new(self, date, events, block).table
  end

  class Calendar < Struct.new(:view, :date, :events, :callback)
    HEADER = %w[Sun Mon Tues Wed Thu Fri Sat]
    START_DAY = :sunday

    delegate :content_tag, to: :view

    def table
      content_tag :table, class: 'calendar' do
        header + week_rows
      end
    end

    def header
      content_tag :tr, class: 'cal-header' do
        HEADER.map { |day| content_tag :th, day }.join.html_safe
      end
    end

    def week_rows
      weeknum = 0
      weeks.map do |week|
        content_tag :tr, class: 'cal-week', id: "week-#{weeknum += 1}" do
          week.map { |day| day_cell(day) }.join.html_safe
        end
      end.join.html_safe
    end

    def day_cell(day)
      content_tag :td, view.capture(day, &callback),
                  id: day.to_formatted_s(:db),
                  class: day_classes(day)
    end

    def day_classes(day)
      event = event(day)
      classes = ['cal-day']
      classes << 'past'     if day < Date.today
      classes << 'today'    if day == Date.today
      classes << 'notmonth' if day.month != date.month
      classes << 'selected' unless event.nil?
      classes << event.try(:css_class)
      classes.flatten.compact.join(' ')
    end

    def weeks
      first = date.beginning_of_month.beginning_of_week(START_DAY)
      last = date.end_of_month.end_of_week(START_DAY)
      (first..last).to_a.in_groups_of(7)
    end

    # Select the first event for a given day from our Array of Events
    def event(day)
      key = day.to_formatted_s(:db)
      events.select{|e| e.date == key}.first
    end

  end
end