# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
calendar_ready = ->
  pad = (str, max) ->
    str = str.toString()
    ( if str.length < max then pad("0" + str, max) else str )

  findDateElement = (searchDate) ->
    allElements = document.getElementsByTagName("*")
    i = 0

    while i < allElements.length
      # Element exists with attribute. Add to array.
      return allElements[i] if ( allElements[i].getAttribute('data-date') == searchDate )
      i++

  $("#conflict_calendar").fullCalendar
    eventSources: [
      url: $("#conflict_calendar").data("source-url")
    ]

    eventRender: (event, element) ->
      _date = event.start.getFullYear() + '-' + pad(( event.start.getMonth() + +1 ),2) + '-' + pad(event.start.getDate(),2)
      element.find(".fc-event-title").text('')
      $(findDateElement(_date.toString())).addClass('selected')
      true

    dayClick: (date, allDay, jsEvent, view) ->
      # change the day's background color just for fun
      $.ajax
         url: $("#conflict_calendar").data("update-url")
         data:
           date: date

#      $(this).toggleClass('selected')
      location.reload()

$(document).ready(calendar_ready)
$(document).on 'page:load', calendar_ready
$(document).on 'cocoon:after-insert', calendar_ready
