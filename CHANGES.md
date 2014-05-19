WWIT Backstage Change Log
-------------------------

### v2.1.8 - _Update Rails (bugfixes)_
  - Update rails to version 4.1.1
  - Removing the auto-refresh because it's causing some problems
  
### v2.1.7 - _Shift Publishing_
 Status: _Deployed 2014-04-24_

 - Auto-scheduled shifts are now hidden from members and must be published before being visible.
 - Added approval timestamp to messages and lifted restrictions on sent-to list in show view.
 - If a member has access to view an Announcement, they are able to see who it was sent to.
 - Auto-refresh a member's dashboard page every 5 minutes

### v2.1.6 - _Record Deletion Hotfix_
 Status: _Deployed 2014-03-24_

 - Improved verbiage on all deletion prompts
 - Only Admin can delete Shows

### v2.1.5 - _Conflict Auto-Lock Hotfix_
 Status: _Deployed 2014-03-20_

 - Only auto-lock conflicts for the month being scheduled.  Future conflicts
   should remain unlocked.

### v2.1.4 - _Minor Revision_
 Status: _Deployed 2014-03-20_

 - Revert back to show page after create/update in Shows (better UX)
 
### v2.1.3 - _Back Button Fix_
 Status: _Deployed 2014-03-19_

 - Duplicates month controls on the bottom of a few longer pages
 - Redesign back button to fix issues introduced in v2.1.2

### v2.1.2 - _Auto-Schedule Fixes_
 Status: _Deployed 2014-03-18_

 - New Schedule view, showing all assigned and unassigned shifts
 - Refactors auto-schedule code to use Shifts instead of Shows (more efficient scheduling)
 - Assigns a random member with the least amount of current shifts (evens out schedule)
 - Back button on most pages now actually takes you back to where you were. I know, right?

### v2.1.1 - _Maintenance Release_
 Status: _Deployed 2014-03-17_

 - Fixes bug keeping Auto-Schedule from working properly
 - Adds "Exempt from Conflicts" flag to members, allowing auto-schedule to ignore conflict limits
 - Adds "Ignore Max Shifts" flag to Skills, so certain skills can be scheduled more than the normal limits
 - Minor visual improvements (specifically in Member index)

### v2.1.0 - _Enhancement Release_
 Status: _Deployed 2014-03-13 @ 4:30 PM_

 - Implements conflicts limit on auto-schedule code
 - Mini-Calendar on dashboard for Crew Shifts
 - Tooltips for Skill codes and Icons
 - Footer and SiteTag no longer show on small (mobile) screens
 - Adds '# of Shifts' column to Conflicts Management list
 - Various minor bug fixes / screen improvements

### v2.0.1 - _bug fix release_
 Status: _Deployed 2014-03-13 @ 10:06 AM_

 - Fixes bug wherein regular members did not have access to cast list
 - Fixes bug wherein MC's could not send out Cast Announcements

### v2.0.0 - _Initial Release_
 Status: _LIVE 2014-03-01_
