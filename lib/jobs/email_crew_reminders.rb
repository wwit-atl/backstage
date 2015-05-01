module Jobs
  class EmailCrewReminders < RecurringJob

    def perform
      Shift.for_date(Date.today).each do |shift|
        Audit.logger :mail, "Sending reminder to #{shift.member.fullname.strip} for #{shift.skill.name.strip} on #{shift.show.gregorian_date}"
        BackstageMailer.schedule_reminder(shift).deliver_now
      end
    end

  end
end
