README
======

This is the back-end members only website for Whole World Improv Theatre.

Written by Donovan C. Young
Copyright (c) 2013 Whole World Improv Theatre

Development Roadmap
-------------------

- Dashboard
  - Calendar of Events
  - Upcoming Shows/Shifts
  - Latest Notes
  - Latest Announcements
  - Quick Links to
    - New Announcement
    - New Note

- Roles (has_and_belongs_to_many Members)
  - Admin
  - Management
  - Main Stage
  - Apprentice
  - Unusual Suspects
  - ISP
  - Sponsors
  - Friends

- Skills
  - Shift
    - EmCee
    - House Manager
    - Stage Manager
    - Lights
    - Sound
    - Camera
    - Suggestions
    - Bartending
  - Performance
    - stage_presence

- Members
  - Username
  - Full Name
  - Email
  - Phone(s)
  - Note(s)
  - Role(s)
  - Skill(s)

- PerformanceMatrix
  - stage_presence

- Stages
  - Up Right
  - Down Right
  - Up Left
  - Down Left
  - Stage Right
  - Stage Left
  - Center

- Shows
  - Date
  - CallTime
  - ShowTime
  - EmCee(s)
  - Actor(s)
  - Shift(s)
  - Scene(s)
  - Note(s)

- Scenes
  - Actor(s)
  - Stage
  - Game
  - Suggestion(s) [Freeform or pick from previous entries]
  - Note(s)

- Suggestions
  - Who?
  - Where?
  - What?
  - Text

- Renegades
  - Date
  - Runtime
  - Name
  - Description
  - Format

- Games
  - Name
  - Skill Level [Beginner, Intermediate, Advanced]
  - Suggested # of Player
  - Description

- Notes (behave like comments)
  - Member
  - Schedule
  - Show

- Announcements
  - To All (Members)
  - To Company  -> Roles checked as 'Include In Company'
  - To Role(s)  -> Through Members
  - To Skill(s) -> Through Members
  - To Member(s)

