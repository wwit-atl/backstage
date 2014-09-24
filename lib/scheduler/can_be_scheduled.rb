module Scheduler
  module CanBeScheduled
    extend ActiveSupport::Concern

    module ClassMethods
      def can_be_scheduled
        include Scheduler::CanBeScheduled::LocalInstanceMethods
      end

      def schedule(date = Date.today)
        @exceptions = {}
        Audit.logger :autosched, "Begin scheduling all available shifts for #{date.strftime('%B, %Y')}"
        self.for_month(date).by_skill_priority.each do |instance|
          @exceptions.merge! instance.schedule if instance.skill.autocrew and instance.member.nil?
        end
        return @exceptions
      end
    end

    module LocalInstanceMethods

      def schedule
        @exceptions = {}

        Audit.logger :autosched, "Begin scheduling for #{self.show.title}: #{self.skill.name}"

        unless self.skill.autocrew
          Audit.logger :autosched, "#{self.show.title}: #{self.skill.name} is not auto-scheduled, skipping"
          return {}
        end

        unless self.member.nil?
          Audit.logger :autosched, "#{self.show.title}: #{self.skill.name} is already crewed by #{self.member.name}"
          return {}
        end

        crew = get_crew(self)

        if crew.nil?
          Audit.logger :autosched, "No eligible members were available for #{self.skill.name}"
          ( @exceptions[self.show.date] ||= [] ) << self.skill.name
        else
          self.member = crew
          self.hidden = true # don't publish the auto-generated shifts
          self.save!
        end

        return @exceptions
      end

    end

    private

    # When successful, returns a single member name, vetted to work the shift
    def get_crew(shift)
      crew_list = {}

      Audit.logger :autosched, "Looking for eligible crew for #{shift.skill.name}"

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
        ( crew_list[c] ||= [] ) << member
      end

      member = crew_list[crew_list.keys.min].sample
      Audit.logger :autosched, "Randomly assigning #{member.name} to #{self.skill.name} out of #{crew.count} eligible members."

      member
    end

    # Runs through a list of members, checking if they eligible to work this show
    def vet_members(members, min_shifts, max_shifts)
      crew_list       = []
      potential_crew  = []
      same_group_crew = []

      # Audit.logger :autosched, "There are #{members.count} members being vetted"

      members.each do |member|
        eligible = member.eligible_for_shift?(self.show, min_shifts, max_shifts)

        # Audit.logger :autosched, "Vetting #{member.name}"

        case eligible
          when 0 # Member is eligible
            Audit.logger :autosched, "Adding #{member.name} to eligible crew_list"
            crew_list << member
          when 1 # Member part of same group, add to same_group list
            Audit.logger :autosched, "#{member.name} is in the same group as the show (#{self.show.group.name}), will only schedule if no other members qualify."
            same_group_crew << member
          when 2 # Member at min shift limit, add to the potential list
            Audit.logger :autosched, "#{member.name} is at min shift limit, adding to potential list."
            potential_crew << member
          when 3 then Audit.logger :autosched, "#{member.name} is at the maximum number of shifts."
          when 4 then Audit.logger :autosched, "#{member.name} is already scheduled on another shift."
          when 5 then Audit.logger :autosched, "#{member.name} has a conflict for this date."
          when 6 then Audit.logger :autosched, "#{member.name} is not a member of any shift groups."
          else        Audit.logger :autosched, "#{member.name} wasn't scheduled, but I have no idea why... this shouldn't happen."
        end
      end

      # If the crew list is empty but we have potential crew members, re-run using those
      if crew_list.empty?
        if same_group_crew.count > 0
          # If Same-Group members exist, go ahead and assign them anyway (randomly)
          Audit.logger :autosched, 'Eligible Crew list is empty, assigning same-group members'
          crew_list = same_group_crew
        elsif potential_crew.count > 0
          Audit.logger :autosched, 'Eligible Crew list is empty, increasing min shift and re-processing with potential list'
          crew_list = vet_members(potential_crew, min_shifts+1, max_shifts)
        end
      end

      # Return the crew list (even if empty)
      # Audit.logger :autosched, "Found #{crew_list.count} members whom are eligible"
      crew_list
    end

  end
end

ActiveRecord::Base.send :include, Scheduler::CanBeScheduled
