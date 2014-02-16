module Scheduler
  module CanBeScheduled
    extend ActiveSupport::Concern

    module ClassMethods
      def can_be_scheduled
        include Scheduler::CanBeScheduled::LocalInstanceMethods
      end

      def schedule
        @exceptions = {}
        Rails.logger.info "Scheduling all available shifts"
        self.order('RANDOM()').each do |instance|
          @exceptions.merge! instance.schedule
        end
        return @exceptions
      end
    end

    module LocalInstanceMethods

      def schedule
        @exceptions = {}

        Rails.logger.debug "Scheduling shifts for #{self.name}"

        raise( Scheduler::NoShiftError, 'Show has no shifts to assign' ) if self.shifts.empty?

        self.shifts.by_skill_priority.each do |shift|
          Rails.logger.debug "... Checking #{shift.skill.name}"

          next unless shift.skill.autocrew
          next unless shift.member.nil?

          crew = get_crew(shift)

          if crew.nil?
            ( @exceptions[shift.show.date] ||= [] ) << shift.skill.name
          else
            Rails.logger.info "Assigning #{crew.name} to #{shift.skill.name}"
            shift.member = crew
            shift.save!
          end
        end

        @exceptions.each { |date,shift| Rails.logger.error "No eligible members were available for #{shift} on #{date.to_s}" }
        return @exceptions
      end

    end

    private

    # When successful, returns a single member name, vetted to work the shift
    def get_crew(shift)
      Rails.logger.debug "Looking for eligible crew for #{shift.skill.name}"

      min_shifts = Konfig.where(name: 'MemberMinShifts').first.value.to_i || 3
      max_shifts = Konfig.where(name: 'MemberMaxShifts').first.value.to_i || 5

      if shift.skill.training
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
      crew_list       = []
      potential_crew  = []
      same_group_crew = []

      members.each do |member|
        eligible = member.eligible_for_shift?(self, min_shifts, max_shifts)
        next unless eligible

        Rails.logger.debug "Vetting #{member.name}"

        case eligible
          when 0
            # Add the member to the potential list
            Rails.logger.debug "#{member.name} is at shift limit"
            potential_crew << member
          when 1
            # Member part of same group, add to same_group list
            Rails.logger.debug "#{member.name} is part of #{self.group.name}"
            same_group_crew << member
          else
            # If we made it here, add the member to the crew list
            Rails.logger.debug "Adding #{member.name} to eligible crew_list"
            crew_list << member
        end
      end

      # If the crew list is empty but we have potential crew members, re-run using those
      if crew_list.empty?
        if same_group_crew.size > 0
          # If Same-Group members exist, go ahead and assign them anyway (randomly)
          Rails.logger.debug 'Eligible Crew list is empty, assigning same-group members'
          crew_list << same_group_crew.sample(1)
        elsif potential_crew.size > 0
          crew_list = vet_members(potential_crew, min_shifts+1, max_shifts)
        end
      end

      # Return the crew list (even if empty)
      Rails.logger.debug "#{crew_list.size} members eligible"
      crew_list
    end

  end
end

ActiveRecord::Base.send :include, Scheduler::CanBeScheduled
