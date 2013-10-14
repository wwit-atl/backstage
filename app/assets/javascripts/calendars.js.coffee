# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
calendar_ready = ->
  $("#conflict_calendar").fullCalendar
    dayClick: (date, allDay, jsEvent, view) ->
      # change the day's background color just for fun
      $(this).toggleClass('selected')

$(document).ready(calendar_ready)
$(document).on 'page:load', calendar_ready
$(document).on 'cocoon:after-insert', calendar_ready
