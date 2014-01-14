# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.calendarClick = (eventDate) ->
  # Get the event clicked and toggle the selected class
  event = $(document.getElementById(eventDate))
  event.toggleClass('selected')

  # Toggle locked class for dates before today.
  today = new Date()
  event.toggleClass('locked') if new Date(eventDate) < today

  # This is the div holding the maximimum conflicts message
  noteDiv = $('#max-note')

  # Get how many conflicts are curretly selected
  curCount = $('.selected').length

  # What's our max?  (sent via data-max-conflicts)
  maxCount = noteDiv.attr('data-max-conflicts')

  $('span.cur-count').text(curCount)
  $('span.max-count').text(maxCount)

  if ( curCount < maxCount )
    # Remove the at-limit class (if applied)
    noteDiv.removeClass('at-limit') if noteDiv.hasClass('at-limit')

  # show or hide the number of conflicts messages
  if ( curCount > 0 )
#    if it's not already visible, make it so
#    unless noteDiv.is(':visible')
#      noteDiv.css('opacity', 0).slideDown().animate({opacity: 1})

    if ( curCount >= maxCount )

      # We're using .promise().done(function() {} ) to ensure our animations complete in sequence.
      if ( curCount > maxCount )


        # Apply over-limit class if we haven't already done so
        unless noteDiv.hasClass('over-limit')
          noteDiv.fadeOut().promise().done( ->
            noteDiv.addClass('over-limit').fadeIn()

            # Remove the at-limit class (if applied)
            noteDiv.removeClass('at-limit') if noteDiv.hasClass('at-limit')

            # and show the over limit note, too
            $('.over-limit-note').slideDown()
          )

      else
        # Must be ==, so remove over-limit class if it's been applied
        if noteDiv.hasClass('over-limit')
          noteDiv.fadeOut().promise().done( ->
            noteDiv.removeClass('over-limit').fadeIn()

            # and hide the over limit note
            $('.over-limit-note').slideUp()
          )

        # and then add the at-limit class
        noteDiv.addClass('at-limit') unless noteDiv.hasClass('at-limit')

  else
    # less than 1, hide all messages
#    noteDiv.animate({opacity: 0}).slideUp()

