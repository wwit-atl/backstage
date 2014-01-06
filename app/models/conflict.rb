class Conflict < ActiveRecord::Base
  belongs_to :member

  scope :last_month, lambda { where(year: (Date.today - 1.month).year).where(month: (Date.today - 1.month).month) }
  scope :next_month, lambda { where(year: (Date.today + 1.month).year).where(month: (Date.today + 1.month).month) }
  scope :this_month, lambda { where(year: Date.today.year).where(month: Date.today.month) }
  scope :current, -> { this_month | next_month }

  scope :by_date, -> { order([:year, :month, :day]) }
  default_scope by_date

  def date
    '%4d-%02d-%02d' % [year, month, day]
  end

  def datetime
    date.to_time
  end

  def db_date
    datetime.to_formatted_s(:db)
  end

  def as_json(options = {})
    {
        :id => self.id,
        :title => '** CONFLICT **',
        :start => self.db_date,
        :allDay => true,
        :recurring => false,
        :color => 'red',
        :textColor => 'darkred'
    }
  end

  def self.for_date(date = nil)
    if my_date = Date.parse(date)
      self.where(year: my_date.year).where(month: my_date.month).where(day: my_date.day)
    else
      self.none
    end
  end

end
