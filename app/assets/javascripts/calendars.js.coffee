# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
window.calendarClick = (eventDate, cssClass, linkURL) ->
  event = $(document.getElementById(eventDate))
  event.toggleClass(cssClass)

  # Set or Remove conflicts
  $.ajax
    url: linkURL
    data:
      date: eventDate

  # Refresh the page
  $.ajax
    url: '',
    context: document.body,
    success: (s,x) ->
      $(this).html(s)

