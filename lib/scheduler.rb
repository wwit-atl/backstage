require 'scheduler/can_be_scheduled'
require 'scheduler/can_create_shows'

module Scheduler
  class NoMemberError < StandardError ; end
  class NoSkillError  < StandardError ; end
  class NoShiftError  < StandardError ; end
  class NoShowError   < StandardError ; end
end

