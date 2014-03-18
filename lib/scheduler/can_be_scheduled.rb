module Scheduler
  module CanBeScheduled
    extend ActiveSupport::Concern

    module ClassMethods
      def can_be_scheduled
        include Scheduler::CanBeScheduled::LocalInstanceMethods
      end

      def schedule(date = Date.today)
        @exceptions = {}
        Rails.logger.info "[AUTOSCHED] Scheduling all available shifts for #{date.strftime('%B, %Y')}"
        self.for_month(date).by_skill_priority.each do |instance|
          @exceptions.merge! instance.schedule
        end
        return @exceptions
      end
    end

    module LocalInstanceMethods

      def schedule
        @exceptions = {}

        Rails.logger.debug "[AUTOSCHED] >> Scheduling #{self.show.title} #{self.skill.name}"

        #return { self.date => [ "#{self.name}; has no shifts to assign" ] } if self.shifts.empty?
        # return {} if self.shifts.empty?

        # Rails.logger.debug "[AUTOSCHED] Checking #{self.skill.name}"

        return {} unless self.skill.autocrew
        return {} unless self.member.nil?

        crew = get_crew(self)

        if crew.nil?
          ( @exceptions[self.show.date] ||= [] ) << self.skill.name
        else
          Rails.logger.info "[AUTOSCHED] Assigning #{crew.name} to #{self.skill.name}"
          self.member = crew
          self.save!
        end

        @exceptions.each { |date,shift| Rails.logger.error "[AUTOSCHED] No eligible members were available for #{shift} on #{date.to_s}" }
        return @exceptions
      end

    end

    private

    # When successful, returns a single member name, vetted to work the shift
    def get_crew(shift)
      crew_list = {}

      Rails.logger.debug "[AUTOSCHED] >> Looking for eligible crew for #{shift.skill.name}"

      min_shifts = max_shifts = -1

      if shift.skill.limits
        min_shifts = Konfig.where(name: 'MemberMinShifts').first.value.to_i || 3
        max_shifts = Konfig.where(name: 'MemberMaxShifts').first.value.to_i || 5
      end

      if shift.skill.training
        crew_members = Member.schedulable.has_skill(shift.skill.code) || []
      else
        crew_members = Member.schedulable || []
      end

      crew = vet_members(crew_members, min_shifts, max_shifts)

      # Return nil or a random crew member
      return nil if crew.empty?

      # Select a random member with the least amount of shifts
      crew.each do |member|
        c = member.shifts.for_month(shift.show.date).count
        crew_list[c] = [] if crew_list[c].nil?
        crew_list[c] << member
      end

      crew_list[crew_list.keys.min].sample
    end

    # Runs through a list of members, checking if they eligible to work this show
    def vet_members(members, min_shifts, max_shifts)
      crew_list       = []
      potential_crew  = []
      same_group_crew = []

      Rails.logger.debug "[AUTOSCHED] >> #{members.count} members being vetted"

      members.each do |member|
        eligible = member.eligible_for_shift?(self.show, min_shifts, max_shifts)
        next unless eligible

        Rails.logger.debug "[AUTOSCHED] >> Vetting #{member.name}"

        case eligible
          when 0
            # Add the member to the potential list
            Rails.logger.debug "[AUTOSCHED] >> #{member.name} is at shift limit, adding to potential list."
            potential_crew << member
          when 1
            # Member part of same group, add to same_group list
            Rails.logger.debug "[AUTOSCHED] >> #{member.name} is in the same group as the show (#{self.show.group.name}), will only schedule if no other members qualify."
            same_group_crew << member
          else
            # If we made it here, add the member to the crew list
            Rails.logger.debug "[AUTOSCHED] >> Adding #{member.name} to eligible crew_list"
            crew_list << member
        end
      end

      # If the crew list is empty but we have potential crew members, re-run using those
      if crew_list.empty?
        if same_group_crew.count > 0
          # If Same-Group members exist, go ahead and assign them anyway (randomly)
          Rails.logger.debug '[AUTOSCHED] >> Eligible Crew list is empty, assigning same-group members'
          crew_list = same_group_crew
        elsif potential_crew.count > 0
          Rails.logger.debug '[AUTOSCHED] >> Eligible Crew list is empty, increasing min shift and re-processing with potential list'
          crew_list = vet_members(potential_crew, min_shifts+1, max_shifts)
        end
      end

      # Return the crew list (even if empty)
      Rails.logger.debug "[AUTOSCHED] >> #{crew_list.count} members are eligible"
      crew_list
    end

  end
end

ActiveRecord::Base.send :include, Scheduler::CanBeScheduled
