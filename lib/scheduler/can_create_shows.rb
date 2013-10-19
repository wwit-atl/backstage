module Scheduler
  module CanCreateShows
    extend ActiveSupport::Concern

    module ClassMethods
      def can_create_shows
        include Scheduler::CanCreateShows::LocalInstanceMethods
      end

      def create_shows_for(year = Time.now.year, month = Time.now.month)
        date = Time.parse("#{year}-#{month}-01")
        loop_date = date

        while loop_date.month == date.month do
          self.send(:all).each do |template|
            if template.dow.to_i == loop_date.strftime('%w').to_i
              CanCreateShows.create_show(loop_date, template)
            end
          end
          loop_date += 1.day
        end
      end
    end

    module LocalInstanceMethods
    end

    private

    def self.create_show(date, template)
      # Abort if the show already exists
      return unless Show.where(date: date, showtime: template.showtime).empty?

      logger.info "Creating show for #{template.name} on #{date.strftime('%m/%d/%Y')}"

      # Create the show
      Show.create(
          date:     date,
          name:     template.name,
          showtime: template.showtime,
          calltime: template.calltime,
          skills:   template.skills
      )
    end
  end
end

ActiveRecord::Base.send :include, Scheduler::CanCreateShows
