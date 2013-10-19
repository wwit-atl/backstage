module Scheduler
  class NoMemberError < StandardError
  end
  class NoSkillError < StandardError
  end
  class NoShowError < StandardError
  end

  module CanBeScheduled
    extend ActiveSupport::Concern

    included do
    end

    module ClassMethods

      def can_be_scheduled
        include Scheduler::CanBeScheduled::LocalInstanceMethods
      end
    end

    module LocalInstanceMethods

      def schedule
        @show = self.show
        raise( Scheduler::NoShowError, 'No show provided for Shift' ) if @show.nil?

        @skill = self.skill
        raise( Scheduler::NoSkillError, 'No skill provided for Shift' ) if @skill.nil?

        crew = get_crew

        if crew.empty?
          raise Scheduler::NoMemberError, "No members available to crew #{@show.name}:#{@skill.name}"
        else
          self.member = crew
        end
      end

    end

    private

    # When successful, returns a single member name, vetted to work the shift
    def get_crew
      min_shifts = Konfig.member_min_shifts
      max_shifts = Konfig.member_max_shifts

      if @skill.training?
        members = Member.crewable.has_skill(@skill.code) || []
      else
        members = Member.crewable || []
      end

      crew = vet_members(members, min_shifts, max_shifts)

      crew.empty? ? nil : crew.sample
    end

    # Runs through a list of members, checking if they eligible to work this show
    def vet_members(members, min_shifts, max_shifts)
      crew = []
      potential_crew = []

      members.each do |member|
        # Does the member have a conflict for this date?
        next if member.conflict?(@show.date)

        # Is the member already scheduled on a shift for this show?
        next if member.has_shift_for?(@show)

        # Is the member already at the maximum number of shifts?
        next if member.shifts.count >= max_shifts

        # Has the member reached the minimum shift limit?
        # If so, add them to the potential crew list
        if member.shifts.count >= min_shifts
          potential_crew << member
          next
        end

        # We made it here, add the member to the crew list
        crew << member
      end

      # If the crew list is empty but we have potential crew members, re-run using those
      if crew.empty? and potential_crew.size > 0
        crew = vet_members(potential_crew, min_shifts+1, max_shifts)
      end

      # Return the crew list (even if empty)
      crew
    end

  end
end

ActiveRecord::Base.send :include, Scheduler::CanBeScheduled
