module Scheduler
  module CanBeScheduled
    extend ActiveSupport::Concern

    module ClassMethods
      def can_be_scheduled
        include Scheduler::CanBeScheduled::LocalInstanceMethods
      end

      def schedule
        Rails.logger.info "Scheduling all available shifts"
        self.order('RANDOM()').each do |instance|
          instance.schedule
        end
      end
    end

    module LocalInstanceMethods

      def schedule
        @show       = self
        @exceptions = []

        raise( Scheduler::NoShiftError, 'Show has no shifts to assign' ) if self.shifts.empty?

        self.shifts.by_skill_priority.each do |shift|
          next unless shift.skill.autocrew?
          next unless shift.member.nil?

          crew = get_crew(shift)

          if crew.nil?
            @exceptions << "No members available for #{shift.skill.name}"
          else
            Rails.logger.info "Assigning #{crew.name} to #{shift.skill.name}"
            shift.member = crew
            shift.save!
          end
        end

        if @exceptions
          @exceptions.each { |e| Rails.logger.error e.to_s }
          return false
        end

        return true
      end

    end

    private

    # When successful, returns a single member name, vetted to work the shift
    def get_crew(shift)
      min_shifts = Konfig.member_min_shifts.to_i
      max_shifts = Konfig.member_max_shifts.to_i

      if shift.skill.training?
        crew_members = Member.crewable.has_skill(shift.skill.code) || []
      else
        crew_members = Member.crewable || []
      end

      crew = vet_members(crew_members, min_shifts, max_shifts)

      # Return nil or a random crew member
      crew.empty? ? nil : crew.sample
    end

    # Runs through a list of members, checking if they eligible to work this show
    def vet_members(members, min_shifts, max_shifts)
      crew_list = []
      potential_crew = []

      members.each do |member|
        current_shift_count = member.shift_count_for_month(@show.month)

        # Does the member have a conflict for this date?
        next if member.conflict?(@show.date)

        # Is the member already scheduled on a shift for this show?
        next if member.has_shift_for?(@show)

        # Is the member already at the maximum number of shifts?
        next if current_shift_count >= max_shifts

        # Has the member reached the minimum shift limit?
        # If so, add them to the potential crew list
        if current_shift_count >= min_shifts
          potential_crew << member
          next
        end

        # We made it here, add the member to the crew list
        crew_list << member
      end

      # If the crew list is empty but we have potential crew members, re-run using those
      if crew_list.empty? and potential_crew.size > 0
        crew_list = vet_members(potential_crew, min_shifts+1, max_shifts)
      end

      # Return the crew list (even if empty)
      crew_list
    end

  end
end

ActiveRecord::Base.send :include, Scheduler::CanBeScheduled
