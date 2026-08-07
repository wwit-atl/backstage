WWIT Backstage Change Log
-------------------------

### v2.7.0 - _Kamal Deployment and Security Remediation_
 Status: _Deployed 2026-08-06_

 Note: this log was not maintained between v2.1.8 and v2.6.0. This entry covers
 everything since the v2.6.0 tag (2023-02-20).

 **Security**

 - The production `SECRET_KEY_BASE` had been committed to `config/deploy.yml` in
   a public repository since 2024-11-21. Combined with Rails 4.2's default
   `:marshal` cookie serializer and a publicly reachable app, that allowed
   forging session cookies carrying arbitrary Marshal payloads. The key has been
   rotated and the old value must never be reused.
 - Cookie serializer pinned to `:json`, so any future key disclosure is session
   forgery rather than remote code execution. All members were signed out once.
 - Deploy secrets moved out of the repository into an age-encrypted file held
   only on the deploy host. See `docs/SECRETS.md` for setup and rotation.
 - Added `bin/verify-secrets`, which checks the encrypted secrets without
   printing their values.
 - Production database dumps were being copied into every built image via
   `tmp/`. Excluded, along with `log/` and any `*.dump`/`*.bak`/`*.sql`.
 - Removed `.travis.yml`, which carried a CodeClimate token.
 - `force_ssl` is prepared but still commented out, pending verification that
   `X-Forwarded-Proto` reaches Rails from the upstream proxy.

 **Deployment**

 - Migrated from AWS Elastic Beanstalk to Kamal; the app now runs as a Docker
   container with a separate `delayed_job` worker role.
 - Repaired the Docker build, which had been failing since Debian buster went
   end-of-life and was removed from `deb.debian.org`.
 - Build time reduced from roughly 25 minutes to 3, and image size from 1.99GB
   to 1.62GB, by assigning ownership during `COPY` rather than a later
   `chown -R` and by dropping the Sprockets cache in the layer that creates it.
 - Added a healthcheck endpoint, dev container support, and `db:local` rake
   tasks. Removed the `therubyracer` dependency.

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
