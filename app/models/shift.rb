require 'icalendar'

class Shift < ActiveRecord::Base
  include Rails.application.routes.url_helpers

  can_be_scheduled

  before_save :generate_uuid

  belongs_to :show
  belongs_to :skill
  belongs_to :member

  #validates_presence_of :show_id, :on => :create

  scope :with_skill, ->(code) { joins(:skill).where(skills: {code: code.to_s.upcase}).readonly(false).first }
  scope :for_month,  ->(date) { joins(:show).where('shows.date >= ? AND date <= ?', date.beginning_of_month, date.end_of_month) }

  scope :unassigned, -> { where(member_id: nil) }

  scope :future, -> { joins(:show).where('shows.date >= ?', Date.today.beginning_of_month) }

  scope :for_date, ->(date = Date.today) do
    if my_date = Date.parse(date.to_s)
      joins(:show).where('shows.date' => my_date)
    end
  end

  scope :by_show,           -> { joins(:show).order('shows.date', 'shows.showtime') }
  scope :by_show_desc,      -> { joins(:show).order('shows.date desc', 'shows.showtime desc') }
  scope :by_skill_priority, -> { joins(:skill).order('skills.priority').readonly(false) }
  scope :by_skill,          -> { by_show.by_skill_priority }
  scope :by_member,         -> { by_show.joins(:member).order(['members.lastname', 'members.firstname']) }

  scope :recent, -> { joins(:show).where('shows.date > ?', Date.today - 1.month) }

  def to_ics
    # Helpers
    skill = self.skill

    # Create the event
    event = Icalendar::Event.new
    event.start           = show.to_datetime(:calltime).strftime('%Y%m%dT%H%M%S')
    event.end             = (show.to_datetime + 4.hours).strftime('%Y%m%dT%H%M%S')
    event.summary         = skill.name
    event.description     = show.name
    event.location        = 'Whole World Improv Theatre; 1216 Spring St NW, Atlanta GA 30309'
    event.klass           = 'PUBLIC'
    event.created         = DateTime.now
    event.url             = show_url(show, host: ( ENV['RAILS_HOST'] || 'backstage.wholeworldtheatre.com' ))
    event.uid             = uuid

    event.add_comment( 'Added by WWIT Backstage 2.0' )

    # Add email alarm 2 hours prior
    event.alarm do
      action        'EMAIL'
      description   "[WWIT-BACKSTAGE-SHIFT] Your #{skill.name} shift starts in 2 hours"
      summary       "#{skill.name} Shift in 2 hours"
      trigger       '-PT2H0M0S'
    end

    # Add display alarm 30 minutes prior
    event.alarm do
      summary       "#{skill.name} shift starts in 30 minutes"
      trigger       '-PT0H30M0S'
    end

    # Return the event
    event
  end

  def date
    show.date.to_formatted_s(:db)
  end

  private

  def generate_uuid
    self.uuid = SecureRandom.uuid if uuid.nil?
  end
end
